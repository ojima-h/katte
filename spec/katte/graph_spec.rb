require 'spec_helper'
require 'katte/graph'

class Katte
  describe Graph do
    before :all do
      @node_a = Node.new(name: "a", :parents => ["b", "c"])
      @node_b = Node.new(name: "b")
      @node_c = Node.new(name: "c")
      @nodes  = [@node_a, @node_b, @node_c]
    end

    it 'build graph from nodes set' do
      graph = Graph.new(@nodes)

      [@node_b, @node_c].all? {|node|
        expect(graph.root).to include node
      }

      expect(@node_b.children).to eq [@node_a]
      expect(@node_c.children).to eq [@node_a]
    end
  end
end
