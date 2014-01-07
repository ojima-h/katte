class Katte::Command
  class Test
    class Abort < StandardError; end

    def self.call(node)
      node.options['callback'].each {|cb| cb.call(node) }
      return true
    rescue Abort => e
      return false
    end
  end
end
