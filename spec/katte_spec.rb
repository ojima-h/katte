require 'spec_helper'
require 'date'

describe Katte do
  describe "#run" do
    before(:each) {
      Katte::Node.clear
      Katte::Plugins.output[:debug].history.clear
    }

    it "execute whole node" do
      Katte.app.run

      result = []
      result << Katte::Plugins.output[:debug].history.pop[:out] until Katte::Plugins.output[:debug].history.empty?

      today = Date.today.strftime("%Y-%m-%d")
      ["#{today}\n", "0\n", "custom:1\n", "custom:2\n"].all? do |line|
        expect(result).to include line
      end
    end
  end
end
