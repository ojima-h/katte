class Katte::Command
  class Hive
    def self.execute(node)
      Katte::Command.simple(node, "hive", "-f", node.path)
    end
  end
end
