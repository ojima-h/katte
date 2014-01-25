require 'find'
require 'logger'
require "katte/version"
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
  attr_reader :options

  def initialize(options = {})
    @env     = Environment.new(options)
    @options = options
    @config  = Katte::Config.config

    @logger = if options[:verbose] || config.mode == 'test'
                Logger.new(STDOUT)
              else
                Logger.new(File.join(@config.log_root, 'katte.log'), 'daily')
              end
    @logger.level = Logger::WARN if config.mode == 'test'
  end

  def run
    node_factory     = config.factory || Katte::Node::Factory
    nodes            = Node::Loader.load(config.recipes_root, node_factory)
    dependency_graph = DependencyGraph.new(nodes)
    filter           = Filter.new(datetime: env.datetime)
    driver           = Driver.new(dependency_graph, filter: filter)

    driver.run

    unless config.mode == 'test'
      File.open(File.join(@config.log_root, 'summary.log'), 'w') do |file|
        file.print <<-EOF
Summary:
  success: #{driver.summary[:success].length}
  fail:    #{driver.summary[:fail].length}
  skip:    #{driver.summary[:skip].length}
        EOF
      end
      File.open(File.join(@config.log_root, 'failed.log'), 'w') do |file|
        driver.summary[:fail].each do |node|
          file.puts node.name
        end
      end
    end
  end

  def exec(recipe_path)
    node_factory = config.factory || Katte::Node::Factory
    node = node_factory.load(recipe_path)
    node.file_type.execute(node)
  end
end
