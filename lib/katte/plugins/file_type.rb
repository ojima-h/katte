class Katte::Plugins
  class FileType < Base
    define_keyword :extname
    define_keyword :comment_by
    index :extname

    def simple_exec(node, program, *args)
      node.open {|out, err|
        pid = spawn(Katte.app.env.to_hash, program, *args, :out => out, :err => err)
        _, status = Process.waitpid2(pid)
        status.success?
      }
    end

    def command
      @command ||= method(:execute)
    end
  end
end
