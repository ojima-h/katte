require 'spec_helper'

class Katte::Plugins
  describe FileType do
    describe "#simple_exec" do
      before(:each) { Katte::Plugins.output[:debug].history.clear }
      it "execute shell script" do
        node = Katte::Node.new(:name   => 'test/sample',
                               :path   => File.expand_path('../../../recipes/test/sample.sh', __FILE__),
                               :output => [Katte::Plugins.output[:debug]])

        file_type = FileType.new
        file_type.simple_exec(node, 'bash', node.path)

        output = Katte::Plugins.output[:debug].history.pop
        result = output[:out].to_a.join

        expect(result).to eq "0\n"
      end
    end
  end
end
