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
  end
end
