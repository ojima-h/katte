require 'yaml'

class Katte
  class Config
    config_klass = Struct.new(:mode,
                              :recipes_root,
                              :result_root,
                              :log_root,
                              :factory)
    @config = config_klass.new

    @config.mode         = ENV['KATTE_MODE'] || 'production'
    @config.recipes_root = File.join(APP_PATH, 'recipes')
    @config.result_root  = File.join(APP_PATH, 'result')
    @config.log_root     = File.join(APP_PATH, 'log')

    def self.config
      self == Katte::Config ? @config : Katte::Config.config
    end
  end
end
