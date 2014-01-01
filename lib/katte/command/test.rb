require 'katte/command/simple'

class Katte::Command
  class Test < Simple
    class Abort < StandardError; end

    def self.execute(node)
      node.options['callback'].each {|cb| cb.call(node) }
      return true
    rescue Katte::Command::Test::Abort => e
      return false
    end
  end
end
