require 'spec_helper'
require 'date'

class Katte
  describe Runner do
    describe "#run" do
      before(:each) {
        Katte::Plugins::Output.find(:debug).history.clear
      }

      it "execute whole node" do
        runner = Katte::Runner.new
        runner.run

        result = []
        debug_plugin = Katte::Plugins::Output.find(:debug)
        result << debug_plugin.history.pop[:out] until debug_plugin.history.empty?

        today = Date.today.strftime("%Y-%m-%d")
        ["#{today}\n", "0\n", "custom:1\n", "custom:2\n"].all? do |line|
          expect(result).to include line
        end
      end
    end
  end
end
