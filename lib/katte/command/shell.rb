class Katte::Command
  class Shell
    def self.call(node)
      Katte::Command.simple(node, "bash", node.path)
    end
  end
end
