class Katte::Command
  class Hive
    def self.call(node)
      Katte::Command.simple(node, "hive", "-f", node.path)
    end
  end
end
