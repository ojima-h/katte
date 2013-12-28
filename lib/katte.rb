require 'find'

require 'katte/config'

class Katte
  def self.config
    @config ||= Katte::Config.new
  end
end
