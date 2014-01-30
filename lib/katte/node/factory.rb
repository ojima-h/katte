require 'pathname'
require 'katte/task_manager/default'
require 'katte/task_manager/sleeper'

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

      parents = directive['require'].map(&:first)
      output  = directive['output'].map {|o| Katte::Plugins.output[o.first.to_sym]}
      period  = (directive['period'].empty? ? 'day' : directive['period'].last)
      options = Hash[directive['option'].map {|k, v| [k, v || true]}]

      params = {
        :name         => name,
        :path         => path,
        :parents      => parents,
        :file_type    => file_type,
        :output       => output,
        :period       => period,
        :task_manager => Katte::TaskManager::Default.instance,
        :options      => options,
      }

      if Katte.app.config.mode == 'test'
        params[:output] = [Katte::Plugins.output[:debug]]
      end

      create(params)
    end

    def add(node)
      @nodes[node.name] = node

      @_cache ||= {} # connection cache

      # connect self to parents if exist
      node.parents.each do |parent|
        if @nodes[parent]
          @nodes[parent].children << node
         else
          (@_cache[parent] ||= []) << node
        end
      end

      # connect children to self
      if children = @_cache.delete(node.name)
        node.children.concat(children)
      end
    end

    def create(params)
      node = Katte::Node.new params
      add(node)
      node
    end
  end
end
