require 'find'
require 'logger'
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
    node_factory = config.factory || Katte::Recipe::NodeFactory.new
    Find.find(config.recipes_root).each(&node_factory.method(:load))
    Katte::Plugins.node.values.each(&node_factory.method(:add))

    filter           = Filter.new(datetime: env.datetime)
    driver           = Driver.new(node_factory.nodes, filter: filter)

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
    node_factory = config.factory || Katte::Recipe::NodeFactory.new
    node = node_factory.load(recipe_path)
    Katte::Plugins.node.each {|_, n|  node_factory.add(n) }

    node.file_type.execute(node)
  end
end
