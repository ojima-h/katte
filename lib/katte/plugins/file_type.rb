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

    def parse(path)
      c = Regexp.escape(comment_by)
      @comment_pattern   ||= /^#{c}|^\s*$/
      @directive_pattern ||= %r{
        ^#{c}\s*                    # comment
        (?<key>\w+)\s*:\s*          # key
        (?<value>[^(\s]+)           # value
        (\((?<params>[^)]*)\))?     # param (optional)
        $
      }x

      directive = Hash.new {|h,k| h[k] = [] }
      open(path) do |io|
        while line = io.gets
          line.chomp!
          break unless     @comment_pattern.match(line)
          next  unless m = @directive_pattern.match(line)

          key, value = m[:key], m[:value]

          directive[key] << value.strip
        end
      end
      directive
    end

  end
end
