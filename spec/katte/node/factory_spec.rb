require 'spec_helper'
require 'stringio'

require 'katte/node/factory'
require 'katte/command/shell'

class Katte::Node
  describe Factory do
    before :all do
      @sample_recipe = File.join(Katte.config.recipes_root, 'test/sample.sh')
    end

    describe ".create" do
      it "returns node object" do
        node = Factory.create(@sample_recipe)
        expect(node.parents).to include('test/sample/sub')
        expect(node.name).to eq 'test/sample'
        expect(node.command).to eq Katte::Command::Shell
        expect(node.period).to eq 'day'
      end
    end
  end
end
