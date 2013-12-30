require 'katte/command/simple'

class Katte::Command
  class Test < Simple
    def self.execute(node)
      node.options['callback'].each {|cb| cb.call(node) }
    end
  end
end
