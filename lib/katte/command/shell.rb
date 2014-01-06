class Katte::Command
  class Shell
    def self.execute(node)
      Katte::Command.simple(node, "bash", node.path)
    end
  end
end
