require 'spec_helper'
require 'katte/command'
require 'katte/command/custom'
require 'katte/node'

class Katte::Command
  describe Custom do
    before :all do
      @node = Katte::Node.new(:name => 'custom',
                              :path => File.expand_path('../../../recipes/custom.rb', __FILE__))
    end

    describe "#execute" do
      it "execute shell script" do
        messages = Katte::Command::Custom.execute(@node).to_a

        expect(messages).to eq [[:next, 0], [:next, 1], [:next, 2], :done]
      end
    end
  end
end
