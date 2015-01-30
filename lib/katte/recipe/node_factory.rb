require 'pathname'

module Katte::Recipe
  class NodeFactory
    @@after_create_hook = nil
    def self.after_create(&proc)
      @@after_create_hook = proc
    end

    def initialize
      pattern_regexp = File.join(Katte.app.config.recipes_root, '(?<name>.+?)\.(?<ext>\w+)')
      @path_pattern = /^#{pattern_regexp}$/

      @nodes = {}
    end

    def load(path)
      return unless FileTest.file? path
      return unless m = @path_pattern.match(path)

      name, ext = m[:name], m[:ext]

      file_type = Katte::Recipe::FileType.find(ext)

      directive = file_type.parse(path)

      requires   = directive['require']
      output     = directive['output'].map {|o| Katte::Plugins.output[o.first.to_sym]}
      period     = (directive['period'].empty? ? 'day' : directive['period'].last)
      options    = Hash[directive['option'].map {|k, v| [k, v || true]}]

      params = {
        :name         => name,
        :path         => path,
        :require      => requires,
        :file_type    => file_type,
        :output       => output,
        :period       => period,
        :options      => options,
      }

      if Katte.app.config.mode == 'test'
        params[:output] = [Katte::Plugins::Output.find(:debug)]
      end

      create(params)
    end

    def create(params)
      node = Katte::Recipe::Node.new params

      @@after_create_hook.call(node, params) if @@after_create_hook

      node
    end
  end
end
