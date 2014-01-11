require 'spec_helper'

class Katte::Command
  describe Custom do
    before :all do
      @recipe = Katte::Recipe.load(File.expand_path('../../../recipes/custom.rb', __FILE__))
      @node = Katte::Node::Factory.create @recipe
    end

    describe "#call" do
      it "execute shell script" do
        messages = Katte::Command::Custom.call(@node).to_a

        expect(messages).to eq [[:next, 0], [:next, 1], [:next, 2], :done]
      end
    end
  end
end
