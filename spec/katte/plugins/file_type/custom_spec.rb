require 'spec_helper'

class Katte::Plugins::FileType
  describe Custom do
    before :all do
      recipe_path = File.expand_path('../../../../recipes/custom.rb', __FILE__)
      @node = Katte::Node::Factory.load(recipe_path)
    end

    describe "#execute" do
      it "send mutiple event" do
        messages = Katte::Plugins::FileType::Custom.new.execute(@node).to_a

        expect(messages).to eq [[:next, "custom/sample_1"], [:next, "custom/sample_2"], :done]
      end
    end
  end
end
