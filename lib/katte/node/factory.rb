require 'pathname'

class Katte::Node
  class Factory
    @@after_create_hook = nil
    def self.after_create(&proc)
      @@after_create_hook = proc
    end

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

      requires = directive['require']
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

    def add(node, params = {})
      @nodes[node.name] = node

      @_cache ||= {} # connection cache

      requires = params[:require] || []

      # connect self to parents if exist
      requires.each do |req, prm|
        if @nodes[req]
          node.add_parent(@nodes[req], *prm)
          @nodes[req].add_child(node, *prm)
         else
          (@_cache[req] ||= []) << [node, prm]
        end
      end

      # connect children to self
      if children = @_cache.delete(node.name)
        children.each {|c, prm|
          c.add_parent(node, *prm)
          node.add_child(c, *prm)
        }
      end
    end

    def create(params)
      node = Katte::Node.new params

      @@after_create_hook.call(node, params) if @@after_create_hook

      add(node, params)
      node
    end
  end
end
