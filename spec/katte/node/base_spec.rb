require 'spec_helper'
module Katte::Recipe
  describe Node do
    describe "#descendants" do
      it "collect all descendants" do
        factory = Katte::Recipe::NodeFactory.new
        node_collection = Katte::Node::Collection.new
        node_collection << factory.create(name: "a", :require => ["b"])
        node_collection << factory.create(name: "b", :require => ["c"])
        node_collection << factory.create(name: "c")

        node_collection.connect

        node_c = node_collection.find("c")

        expect(node_c.descendants.map(&:name)).to eq ["b", "a"]
      end
    end
  end
end
