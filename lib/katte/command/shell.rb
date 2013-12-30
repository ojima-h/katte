require 'katte/command'
require 'katte/command/simple'

class Katte::Command
  class Shell < Simple
    def self.execute(node)
      Katte::Command.open(node) {|env, out, err|
        pid = spawn(env, "/bin/bash", node.path, :out => out, :err => err)
        _, status = Process.waitpid2(pid)
      }
    end
  end
end
