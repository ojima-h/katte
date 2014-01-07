require 'spec_helper'
require 'date'

describe Katte do
  before :all do
    @out_r, @out_w = IO.pipe
    Katte.debug.out = @out_w
  end
  after :all do
    [@out_r, @out_w].each &:close
    Katte.debug.out = nil
  end

  describe "#run" do
    it "execute whole node" do
      result = []
      t = Thread.start { while line = @out_r.gets; result << line; end }

      Katte.run
      t.exit

      today = Date.today.strftime("%Y-%m-%d")
      ["#{today}\n", "0\n", "custom:1\n", "custom:2\n"].all? do |line|
        expect(result).to include line
      end
    end
  end
end
