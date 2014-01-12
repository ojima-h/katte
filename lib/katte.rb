require 'find'
require 'logger'
require 'katte/environment'
require 'katte/config'
require 'katte/plugins'
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

  attr_reader :env
  attr_reader :config
  attr_reader :logger

  def initialize(params = {})
    @env    = Environment.new(params)
    @config = Katte::Config.config
    @logger = Logger.new(STDOUT)
  end

  def run
    node_factory     = config.factory || Katte::Node::Factory
    nodes            = Node::Loader.load(config.recipes_root, node_factory)
    dependency_graph = DependencyGraph.new(nodes)
    filter           = Filter.new(datetime: env.datetime)
    driver           = Driver.new(dependency_graph, filter: filter)

    driver.run
  end
end
