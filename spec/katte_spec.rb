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

  describe "#execute" do
    it "execute shell script" do
      result = []
      t = Thread.start { while line = @out_r.gets; result << line; end }

      Katte.run
      t.exit

      today = Date.today.strftime("%Y-%m-%d")
      expect(result).to eq ["#{today}\n", "0\n"]
    end
  end
end
