require 'find'
require 'logger'
require 'katte/environment'
require 'katte/config'
require 'katte/plugins'
require 'katte/debug'
require 'katte/node'
require 'katte/dependency_graph'
require 'katte/filter'
require 'katte/driver'

class Katte
  def self.new(params = {})
    @instance ||= super(params)
  end
  def self.app(params = {})
    @instance ||= new(params)
  end

  def initialize(params = {})
    @env    = Environment.new(params)
    @config = Config.new
    @logger = Logger.new(STDOUT)

    @plugins = {
      :file_type => {},
      :output    => {},
    }
    load_plugins.each {|p|
      case p.type
      when :file_type then @plugins[:file_type][p.extname] = p
      when :output    then @plugins[:output][p.name] = p
      end
    }
  end

  attr_reader :env
  attr_reader :config
  attr_reader :logger

  def find_plugin(type, extname)
    return (@plugins[type][extname] || Plugins.null)
  end

  def debug
    return unless config.mode == 'test'
    @debug ||= Debug.new
  end

  def run
    nodes            = Node::Loader.load(Katte.app.config.recipes_root)
    dependency_graph = DependencyGraph.new(nodes)
    filter           = Filter.new(datetime: env.datetime)
    driver           = Driver.new(dependency_graph, filter: filter)

    driver.run
  end

  private
  def load_plugins
    Dir[File.expand_path('../katte/plugins/file_type/*.rb', __FILE__),
        File.expand_path('../katte/plugins/output/*.rb', __FILE__),
        File.join(@config.plugins_root, '**', '*.rb')].map {|path|
      next unless FileTest.file? path

      Plugins.load(path)
    }.compact
  end
end
