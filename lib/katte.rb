require 'find'
require 'logger'
require 'katte/config'
require 'katte/debug'
require 'katte/node'
require 'katte/node/factory'
require 'katte/node/loader'
require 'katte/driver'
require 'katte/dependency_graph'
require 'katte/filter'
require 'katte/command'
require 'katte/command/shell'
require 'katte/command/ruby'
require 'katte/command/hive'
require 'katte/file_type/default'
require 'katte/file_type/sql'
require 'katte/environment'

class Katte
  def self.env
    @env ||= Environment.new
  end

  def self.config
    @config ||= Katte::Config.new
  end

  def self.command(extname)
    case extname
    when 'sh'  then Command::Shell
    when 'rb'  then Command::Ruby
    when 'sql' then Command::Hive
    else nil
    end
  end
  def self.file_type(extname)
    case extname
    when 'sql' then FileType::SQL
    else FileType::Default
    end
  end

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end
  def self.debug
    return unless config.mode == 'test'
    @debug ||= Debug.new
  end

  def self.run
    nodes            = Node::Loader.load(Katte.config.recipes_root)
    dependency_graph = DependencyGraph.new(nodes)
    filter           = Filter.new(datetime: env.datetime)
    driver           = Driver.new(dependency_graph, filter: filter)

    driver.run
  end
end
