require 'spec_helper'
require 'stringio'

require 'katte/mode/base'

module Katte::Mode
  describe Base do
    before :all do
      @sample_recipe = 'sample.day.sh'
    end

    describe ".parse" do
      it "returns node object" do
        node = Base.parse(@sample_recipe)
        expect(node.parents).to include('parent')
      end
    end
  end
end
