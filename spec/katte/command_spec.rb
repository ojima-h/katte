require 'spec_helper'

class Katte
  describe Command do
    describe ".simple" do
      before(:each) { Debug::Output.history.clear }
      it "execute shell script" do
        node = Katte::Node.new(:name   => 'test/sample',
                               :path   => File.expand_path('../../recipes/test/sample.sh', __FILE__),
                               :output => Katte.app.find_plugin(:output, :debug).command)

        Command.simple(node, 'bash', node.path)

        output = Debug::Output.history.pop
        result = output[:out].to_a.join

        expect(result).to eq "0\n"
      end
    end
  end
end
