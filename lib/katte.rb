require 'find'
require 'logger'
require 'katte/node'
require "katte/version"
require 'katte/environment'
require 'katte/config'
require 'katte/plugins'
require 'katte/filter'
require 'katte/driver'
require 'katte/recipe'

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

    @logger = if STDOUT.tty?
                Logger.new(STDOUT)
              else
                Logger.new(File.join(@config.log_root, 'katte.log'), 'daily')
              end
    @logger.level = Logger::WARN if config.mode == 'test'
  end

  def run
    nodes = load_nodes

    summary = Driver.run nodes

    unless config.mode == 'test'
      File.open(File.join(@config.log_root, 'summary.log'), 'w') do |file|
        file.print <<-EOF
Summary:
  success: #{summary[:success].length}
  fail:    #{summary[:fail].length}
  skip:    #{summary[:skip].length}
        EOF
      end
      File.open(File.join(@config.log_root, 'failed.log'), 'w') do |file|
        summary[:fail].each do |node|
          file.puts node.name
        end
      end
    end
  end

  def exec(recipe_path)
    node_factory = config.factory || Katte::Recipe::NodeFactory.new
    node = node_factory.load(recipe_path)

    node.file_type.execute(node)
  end

  private
  def load_nodes
    nodes = Node::Collection.new
    load_builtin_nodes.each {|node| nodes.add node }
    load_recipes.each       {|node| nodes.add node }
    nodes
  end
  def load_builtin_nodes
    [
     Plugins::Node::File.new,
     Plugins::Node::Debug.new,
    ]
  end
  def load_recipes
    node_factory = config.factory || Katte::Recipe::NodeFactory.new
    Find.find(config.recipes_root).select {|file|
      File.file? file
    }.map {|file|
      node_factory.load(file)
    }
  end
end
