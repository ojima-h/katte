class Katte::Command
  class Ruby
    def self.call(node)
      Katte::Command.simple(node, "ruby", node.path)
    end
  end
end
