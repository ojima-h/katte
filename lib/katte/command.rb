require 'date'
require 'fileutils'

require 'katte/debug'

class Katte
  class Command
    def self.simple(node, program, *args)
      node.open {|out, err|
        pid = spawn(Katte.app.env.to_hash, program, *args, :out => out, :err => err)
        _, status = Process.waitpid2(pid)
        status.success?
      }
    end
  end
end
