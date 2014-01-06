require 'date'

class Katte
  class Command
    def self.open(node)
      @io_null ||= File.open('/dev/null')

      if Katte.config.mode == 'test'
        yield (Katte.debug.out || @io_null), (Katte.debug.err || @io_null)
      else
        out = File.open(File.join(Katte.config.result_root, node.name, 'w'))
        err = File.open(File.join(Katte.config.log_root   , node.name, 'a'))

        yield out, err
      end
    end

    def self.simple(node, program, *args)
      self.open(node) {|out, err|
        pid = spawn(Katte.env.to_hash, program, *args, :out => out, :err => err)
        _, status = Process.waitpid2(pid)
        return status.success?
      }
    end
  end
end
