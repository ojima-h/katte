class Katte::Command
  class Ruby
    def self.execute(node)
      Katte::Command.simple(node, "ruby", node.path)
    end
  end
end
