require 'katte/command'

class Katte
  class Plugins
    class DSL
      module Base
        def app
          Katte.app
        end
      end
    end

    require 'katte/plugins/dsl/file_type'
    require 'katte/plugins/dsl/output'

    @plugins = {}
    def self.plugins; @plugins; end

    def self.load(path)
      context = DSL.new
      plugin = context.instance_eval(File.read(path), path)

      @plugins[plugin.type] ||= []
      @plugins[plugin.type] << plugin

      return plugin
    end

    def self.null
      @null_plugin ||= Struct.new(:name, :type, :command)
      @null_plugin.new.tap {|p|
        p.name = :null
        p.type = :null
        p.command = ->(*args){ true }
      }
    end
  end
end
