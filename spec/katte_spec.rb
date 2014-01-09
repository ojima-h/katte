require 'spec_helper'
require 'date'

describe Katte do
  describe "#run" do
    before(:each) { Katte::Debug::Output.history.clear }

    it "execute whole node" do
      Katte.app.run

      result = []
      result << Katte::Debug::Output.history.pop until Katte::Debug::Output.history.empty?
      result.map! {|output| output[:out].to_a.join }

      today = Date.today.strftime("%Y-%m-%d")
      ["#{today}\n", "0\n", "custom:1\n", "custom:2\n"].all? do |line|
        expect(result).to include line
      end
    end
  end
end
