require 'spec_helper'
class Katte
  describe Node do
    describe "#descendants" do
      it "collect all descendants" do
        factory = Katte::Node::Factory.new
        node_a = factory.create(name: "a", :require => ["b"])
        node_b = factory.create(name: "b", :require => ["c"])
        node_c = factory.create(name: "c")

        expect(node_c.descendants.map(&:name)).to eq ["b", "a"]
      end
    end
  end
end
