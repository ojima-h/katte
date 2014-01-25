require 'spec_helper'
require 'tempfile'

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
        result = output[:out]

        expect(result).to eq "0\n"
      end
    end

    describe '#parse' do
      around do |spec|
        @recipe_path = Tempfile.open('sample_recipe') do |f|
          f.print <<-EOF
# require: recipe(xxx)
# option: conf1(p1, p2)
# option: conf2()
# option: conf3

echo hello
          EOF
          f.path
        end

        spec.run

        File.delete @recipe_path
      end

      it "parse recipe file" do
        file_type = Katte::Plugins.file_type["sh"]
        directive = file_type.parse(@recipe_path)

        expect(directive).to have_key 'require'
        expect(directive).to have_key 'option'

        expect(directive['require']).to eq ['recipe']
        expect(directive['option']).to  eq ['conf1', 'conf2', 'conf3']
      end
    end
  end
end
