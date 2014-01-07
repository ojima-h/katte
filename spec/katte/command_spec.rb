require 'spec_helper'

class Katte
  describe Command do
    before :all do
      @out_r, @out_w = IO.pipe
      Katte.debug.out = @out_w

      @node = Katte::Node.new(:name => 'test/sample',
                              :path => File.expand_path('../../recipes/test/sample.sh', __FILE__))
    end
    after :all do
      [@out_r, @out_w].each &:close
      Katte.debug.out = nil
    end

    describe "#call" do
      it "execute shell script" do
        result = []
        t = Thread.start { while line = @out_r.gets; result << line; end }
        Katte::Command.simple(@node, 'bash', @node.path)
        t.exit

        expect(result).to eq ["0\n"]
      end
    end
  end
end
