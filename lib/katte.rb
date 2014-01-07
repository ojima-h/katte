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
  def self.env
    @env ||= Environment.new
  end

  def self.config
    @config ||= Config.new
  end

  def self.find_plugin(extname)
    @plugins ||= Hash[load_plugins.map{|p| [p.extname, p] }]

    return (@plugins[extname] || Plugins.null)
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

  private
  def self.load_plugins
    Dir[File.expand_path('../katte/plugins/*.rb', __FILE__),
        File.join(Katte.config.plugins_root, '*.rb')].map {|path|
      return unless FileTest.file? path

      plugin = Plugins.load(path)
      return unless [:name, :extname, :command].all? {|m| plugin.respond_to? m }

      plugin
    }.compact
  end
end
