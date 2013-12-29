require 'spec_helper'
require 'stringio'

require 'katte/node/factory/base'
require 'katte/command/shell'

module Katte::Node::Factory
  describe Base do
    before :all do
      @sample_recipe = File.join(Katte.config.recipes_root, 'test/sample.day.sh')
    end

    describe ".create" do
      it "returns node object" do
        node = Base.create(@sample_recipe)
        expect(node.parents).to include('parent')
        expect(node.name).to eq 'test/sample'
        expect(node.command).to eq Katte::Command::Shell
        expect(node.period).to eq 'day'
      end
    end
  end
end
