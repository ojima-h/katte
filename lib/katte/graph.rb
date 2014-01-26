class Katte
  class Graph
    attr_reader :nodes
    attr_reader :root
    def initialize(nodes)
      @nodes = Hash[nodes.map{|n| [n.name, n] }]

      @root  = []
      nodes.each {|node|
        parents =  node.parents

        if parents.empty?
          @root << node
        else
          parents.each {|p| @nodes[p].add_child(node) }
        end
      }
    end
  end
end
