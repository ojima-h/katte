require 'spec_helper'
require 'stringio'

class Katte::Node
  describe Factory do
    before :all do
      @recipe_path = File.join(Katte.app.config.recipes_root, 'test/sample.sh')
    end

    describe ".load" do
      it "returns node object" do
        node = Katte::Node::Factory.load(@recipe_path)
        expect(node.parents).to include('test/sample/sub')
        expect(node.name).to eq 'test/sample'
        expect(node.file_type).to be_respond_to :execute
        expect(node.period).to eq 'day'
      end
    end
  end
end
