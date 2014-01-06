require 'katte/command'

class Katte::Command
  class Shell
    def self.execute(node)
      Katte::Command.open(node) {|env, out, err|
        pid = spawn(env, "/bin/bash", node.path, :out => out, :err => err)
        _, status = Process.waitpid2(pid)
        return status.success?
      }
    end
  end
end
