require 'katte/command'

class Katte
  Plugin = Struct.new(:name, :extname, :comment, :command)
  class Plugins
    class DSL
      class FileType
        attr_reader :plugin
        def initialize
          @plugin = Plugin.new
        end
        def extname v
          @plugin.extname = v
        end
        def comment_by v
          @plugin.comment = v
        end
        def command &proc
          @plugin.command = proc
        end

        def simple_exec *args
          Katte::Command.simple(*args)
        end
      end
      def file_type name, &proc
        context = FileType.new
        context.instance_eval &proc

        context.plugin.name = name
        context.plugin
      end
    end

    def self.load(path)
      context = DSL.new
      plugin = context.instance_eval(File.read(path), path)

      necessary_attr = [:name, :extname, :command]
      return unless necessary_attr.all? {|attr| plugin.respond_to? attr }

      return plugin
    end

    def self.null
      Plugin.new.tap {|p|
        p.name = :null
        p.command = ->(){ true }
      }
    end
  end
end
