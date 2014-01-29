require 'spec_helper'
require 'stringio'

class Katte::Node
  describe Factory do
    before :all do
      @recipe_path = File.join(Katte.app.config.recipes_root, 'test/sample.sh')
    end

    describe "#load" do
      it "returns node object" do
        factory = Katte::Node::Factory.new
        node = factory.load(@recipe_path)
        expect(node.parents).to include('test/sample/sub')
        expect(node.name).to eq 'test/sample'
        expect(node.file_type).to be_respond_to :execute
        expect(node.period).to eq 'day'
      end
    end

    describe "#create" do
      before :all do
        @factory = Katte::Node::Factory.new
        @factory.create(name: "a")
        @factory.create(name: "b")
        @factory.create(name: "c", parents: ["b"])
        @factory.create(name: "d", parents: ["b"])
      end

      it "register all nodes" do
        expect(@factory.nodes.map(&:name)).to eq %w(a b c d)
      end

      it "connect parents and childs" do
        expect(@factory.nodes("b").children.map(&:name)).to eq %w(c d)
      end
    end
  end
end
