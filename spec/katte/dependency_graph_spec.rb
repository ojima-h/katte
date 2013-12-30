require 'spec_helper'

require 'katte/dependency_graph'

class Katte
  describe DependencyGraph do
    before :all do
      @nodes = []
      @nodes << Node.new(name: "a", options: {'require' => ["b", "c"]})
      @nodes << Node.new(name: "b", options: {})
      @nodes << Node.new(name: "c", options: {})
    end

    it 'build dependency graph of nodes' do
      dependency_graph = DependencyGraph.new(@nodes)

      root_nodes = dependency_graph.root
      root_nodes_names = root_nodes.map(&:name)

      expect(root_nodes.length).to eq 2
      expect(root_nodes_names).to include "b"
      expect(root_nodes_names).to include "c"

      next_nodes = dependency_graph.done(@nodes[1])
      expect(next_nodes).to be_empty

      next_nodes = dependency_graph.done(@nodes[2])
      expect(next_nodes.map(&:name)).to eq ["a"]

      next_nodes = dependency_graph.done(@nodes[0])
      expect(next_nodes).to be_nil
    end

    it "remove broken dependency" do
      pending
      broken_node = Node.new(name: 'd', options: {'require' => ['dummy']})

      graph = DependencyGraph.new(@nodes + [broken_node])
      expect(graph.nodes.keys).not_to include 'd'
    end
    it "raise error when cyclic dependency given" do
      pending
      nodes = [ Node.new(name: 'a', options: {'require' => ['b']}),
                Node.new(name: 'b', options: {'require' => ['a']}) ]

      expect { DependencyGraph.new(nodes) }.to raise_error
    end
  end
end
