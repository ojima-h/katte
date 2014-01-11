require 'spec_helper'
require 'stringio'

class Katte::Node
  describe Factory do
    before :all do
      @sample_recipe = Katte::Recipe.load(File.join(Katte.app.config.recipes_root, 'test/sample.sh'))
    end

    describe ".create" do
      it "returns node object" do
        node = Factory.create(@sample_recipe)
        expect(node.parents).to include('test/sample/sub')
        expect(node.name).to eq 'test/sample'
        expect(node.command).to be_respond_to :call
        expect(node.period).to eq 'day'
      end
    end
  end
end
