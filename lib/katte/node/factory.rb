require 'pathname'

class Katte::Node
  class Factory
    def initialize
      pattern_regexp = File.join(Katte.app.config.recipes_root, '(?<name>.+?)\.(?<ext>\w+)')
      @path_pattern = /^#{pattern_regexp}$/

      @nodes = {}
    end

    def nodes(name = nil)
      name ? @nodes[name] : @nodes.values
    end
      
    def load(path)
      return unless FileTest.file? path
      return unless m = @path_pattern.match(path)

      name, ext = m[:name], m[:ext]

      file_type = Katte::Plugins.file_type[ext]

      directive = file_type.parse(path)

      requires = directive['require'].map(&:first)
      output   = directive['output'].map {|o| Katte::Plugins.output[o.first.to_sym]}
      period   = (directive['period'].empty? ? 'day' : directive['period'].last)
      options  = Hash[directive['option'].map {|k, v| [k, v || true]}]

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
        params[:output] = [Katte::Plugins.output[:debug]]
      end

      create(params)
    end

    def add(node, requires = [])
      @nodes[node.name] = node

      @_cache ||= {} # connection cache

      # connect self to parents if exist
      requires.each do |req|
        if @nodes[req]
          node.parents << @nodes[req]
          @nodes[req].children << node
         else
          (@_cache[req] ||= []) << node
        end
      end

      # connect children to self
      if children = @_cache.delete(node.name)
        children.each {|c| c.parents << node }
        node.children.concat(children)
      end
    end

    def create(params)
      node = Katte::Node.new params
      add(node, params[:require] || [])
      node
    end
  end
end
