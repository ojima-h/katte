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
require 'katte/command/shell'
require 'katte/file_type/default'
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
    when 'sh' then Command::Shell
    else nil
    end
  end
  def self.file_type(extname)
    case extname
    when 'sh' then FileType::Default
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





