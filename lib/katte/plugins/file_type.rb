class Katte::Plugins
  class FileType < Base
    define_keyword :extname
    define_keyword :comment_by
    index :extname

    def simple_exec(node, program, *args)
      node.open {|out, err|
        system(Katte.app.env.to_hash, program, *args, :out => out, :err => err)
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

          key    = m[:key]
          value  = m[:value].strip
          params = m[:params] && m[:params].split(',').map(&:strip).map(&method(:convert_variable))

          directive[key] << [value, params]
        end
      end
      directive
    end

    def convert_variable(value)
      # #{xx} というパターンを env['xx'] で置換する
      value.gsub(/\#\{((?:\\\{|[^\{])+)\}/) {|m| Katte.app.env.to_hash[$1]}
    end
  end
end
