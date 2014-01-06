require 'find'
require 'logger'
require 'katte/config'
require 'katte/debug'
require 'katte/node/factory'
require 'katte/node'
require 'katte/driver'
require 'katte/dependency_graph'
require 'katte/command/shell'
require 'katte/file_type/default'

class Katte
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
    return unless config.env == 'test'
    @debug ||= Debug.new
  end

  def self.run
    nodes = [].tap {|x|
      Find.find(config.recipes_root) do |path|
        x << Node::Factory.create(path)
      end
    }.compact!

    dependency_graph = DependencyGraph.new(nodes)
    driver           = Driver.new(dependency_graph)

    driver.run
  end
end
