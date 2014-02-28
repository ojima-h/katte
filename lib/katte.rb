require 'find'
require 'logger'

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
    (@runner ||= Katte::Runner.new).run
  end

  def exec(recipe_path)
    node_factory = config.factory || Katte::Recipe::NodeFactory.new
    node = node_factory.load(recipe_path)

    node.file_type.execute(node)
  end
end

require 'katte/node'
require "katte/version"
require 'katte/environment'
require 'katte/config'
require 'katte/plugins'
require 'katte/filter'
require 'katte/driver'
require 'katte/recipe'
require 'katte/runner'
