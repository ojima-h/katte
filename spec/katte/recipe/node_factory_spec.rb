require 'spec_helper'

module Katte::Recipe
  describe NodeFactory do
    before :all do
      @recipe_path = File.join(Katte.app.config.recipes_root, 'test/sample.sh')
    end

    describe "#load" do
      it "returns node object" do
        factory = Katte::Recipe::NodeFactory.new
        node = factory.load(@recipe_path)
        expect(node.name).to eq 'test/sample'
        expect(node.file_type).to be_respond_to :execute
        expect(node.period).to eq 'day'
      end
    end

    describe "#create" do
      before :all do
        Katte::Node.clear
        @factory = Katte::Recipe::NodeFactory.new
        @factory.create(name: "a")
        @factory.create(name: "b")
        @factory.create(name: "c", require: ["b", "e"])
        @factory.create(name: "d", require: ["b"])
      end

      it "register all nodes" do
        expect(Katte::Node.all.map(&:name)).to eq %w(a b c d)
      end

      it "connect parents and childs" do
        expect(Katte::Node.find("b").children.map(&:name)).to eq %w(c d)
        expect(Katte::Node.find("c").parents.map(&:name)).to eq %w(b)
      end

      it "ignores unregistered nodes" do
        expect(Katte::Node.find("c").parents.map(&:name)).not_to include "e"
        expect(Katte::Node.find("c").parents).not_to include "e"
      end
    end
  end
end
