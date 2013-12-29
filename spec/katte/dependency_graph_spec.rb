require 'spec_helper'

require 'katte/dependency_graph'

class Katte
  describe DependencyGraph do
    before :all do
      @nodes = []
      @nodes << Node.new("a", nil, 'require' => ["b", "c"])
      @nodes << Node.new("b", nil, {})
      @nodes << Node.new("c", nil, {})
    end

    it 'build dependency graph of nodes' do
      dependency_graph = DependencyGraph.new(@nodes)

      root_nodes = dependency_graph.root
      root_nodes_names = root_nodes.map(&:name)

      expect(root_nodes.length).to eq 2
      expect(root_nodes_names).to include "b"
      expect(root_nodes_names).to include "c"

      next_nodes = dependency_graph.done("b")
      expect(next_nodes).to be_empty

      next_nodes = dependency_graph.done("c")
      expect(next_nodes.map(&:name)).to eq ["a"]

      next_nodes = dependency_graph.done("a")
      expect(next_nodes).to be_nil
    end
  end
end
