class Katte::Command
  class Shell
    def self.execute(node)
      Katte::Command.open(node) {|out, err|
        pid = spawn(Katte.env.to_hash, "/bin/bash", node.path, :out => out, :err => err)
        _, status = Process.waitpid2(pid)
        return status.success?
      }
    end
  end
end
