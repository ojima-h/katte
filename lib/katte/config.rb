require 'yaml'

class Katte
  class Config
    attr_reader :mode

    def initialize
      @mode    = ENV['KATTE_MODE'] || 'test'
      @config = {}

      config_file = File.join(APP_PATH, 'config.yaml')
      return unless FileTest.exists? config_file

      yaml = YAML.load_file(config_file)
      @config = yaml[@mode]
    end

    def recipes_root
      @config['recipes_root'] || File.join(APP_PATH, 'recipes')
    end

    def result_root
      @config['recipes_root'] || File.join(APP_PATH, 'result')
    end
    def log_root
      @config['recipes_root'] || File.join(APP_PATH, 'log')
    end
  end
end
