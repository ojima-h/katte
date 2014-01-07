require 'date'
require 'fileutils'

require 'katte/debug'

class Katte
  class Command
    def self.open(node)
      if Katte.config.mode == 'test'
        Debug::Output.open(node) {|out, err| yield out, err }
      else
        out_file = File.join(Katte.config.result_root, node.name)
        err_file = File.join(Katte.config.log_root   , node.name)

        [out_file, err_file].each {|f| FileUtils.makedirs(File.dirname(f)) }

        File.open(out_file, 'w') {|out|
          File.open(err_file, 'a') {|err|
            yield.call out, err
          }
        }
      end
    end

    def self.simple(node, program, *args)
      self.open(node) {|out, err|
        pid = spawn(Katte.env.to_hash, program, *args, :out => out, :err => err)
        _, status = Process.waitpid2(pid)
        status.success?
      }
    end
  end
end
