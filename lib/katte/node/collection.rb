class Katte::Node::Collection
  include Enumerable

  def each &proc
    @nodes.values.each &proc
  end
  
  def initialize
    @nodes  = {}
  end

  def all
    @nodes.values
  end
  def find(node_name)
    @nodes[node_name]
  end

  def add(node, params = {})
    @nodes[node.name] = node
  end
  alias :<< :add

  def connect
    cache ||= {} # connection cache

    @nodes.values.each do |node|
      # connect self to parents if exist
      node.requires.each do |req, prm|
        if @nodes[req]
          node.add_parent(@nodes[req], *prm)
          @nodes[req].add_child(node, *prm)
        else
          (cache[req] ||= []) << [node, prm]
        end
      end

      # connect children to self
      if children = cache.delete(node.name)
        children.each {|c, prm|
          c.add_parent(node, *prm)
          node.add_child(c, *prm)
        }
      end
    end
  end
end
