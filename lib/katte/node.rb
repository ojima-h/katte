require 'katte/node/base'
module Katte::Node
  class <<self
    def nodes
      @nodes ||= {}
    end
    private :nodes

    def all
      nodes.values
    end
    def find(node_name)
      nodes[node_name]
    end

    def add(node, params = {})
      nodes[node.name] = node

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
    def clear
      @nodes  = {}
      @_cache = {}
    end
  end
end
