class Katte::Plugins
  class Plugin
    Output = Struct.new(:name, :command)
  end

  class DSL
    def output name, &proc
      @__context_filetype__ ||= Class.new do
        attr_reader :plugin
        def initialize
          @plugin = Plugin::Output.new
        end
        def command &proc
          @plugin.command = proc
        end
      end

      context = @__context_filetype__.new
      context.instance_eval &proc
      

      necessary_attr = [:name, :command]
      return unless necessary_attr.all? {|attr| context.plugin.send(attr) }

      context.plugin.name = name
      context.plugin.type = :output

      context.plugin
    end
  end
end
