class Katte::Plugins
  class Plugin
    FileType = Struct.new(:name, :type, :extname, :comment, :command)
  end

  class DSL
    def file_type name, &proc
      @__context_filetype__ ||= Class.new do
        attr_reader :plugin
        def initialize
          @plugin = Plugin::FileType.new
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

      context = @__context_filetype__.new
      context.instance_eval &proc

      plugin = context.plugin

      necessary_attr = [:extname, :command]
      return unless plugin.is_a?(Plugin::FileType) and necessary_attr.all? {|attr| context.plugin.send(attr) }

      plugin.name = name
      plugin.type = :file_type

      plugin
    end
  end
end
