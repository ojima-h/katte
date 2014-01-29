require 'spec_helper'
class Katte
  describe Node do
    describe "#descendants" do
      it "collect all descendants" do
        node_a = Node.new(name: "a", :parents => ["b"])
        node_b = Node.new(name: "b", :parents => ["c"])
        node_c = Node.new(name: "c")
        nodes  = [node_a, node_b, node_c]
        Katte::Graph.new(nodes)

        expect(node_c.descendants.map(&:name)).to eq ["b", "a"]
      end
    end
  end
end
