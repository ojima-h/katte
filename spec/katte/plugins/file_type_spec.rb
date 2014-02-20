require 'spec_helper'
require 'tempfile'

class Katte::Plugins
  describe FileType do
    describe "#simple_exec" do
      before(:each) { Katte::Plugins.output[:debug].history.clear }
      it "execute shell script" do
        node = Katte::Recipe::Node.new(:name   => 'test/sample',
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
      before :all do
        @recipe_path = Tempfile.open('sample_recipe') do |f|
          f.print <<-EOF
# require: path/recipe(xxx)
# option: conf1(p1, p2)
# option: conf2()
# option: conf3

echo hello
          EOF
          f.path
        end
      end
      after(:all) { File.delete @recipe_path if File.exists? @recipe_path}

      it "parse recipe file" do
        file_type = Katte::Plugins.file_type["sh"]
        directive = file_type.parse(@recipe_path)

        expect(directive).to have_key 'require'
        expect(directive).to have_key 'option'

        expect(directive['require']).to eq [['path/recipe', ['xxx']]]
        expect(directive['option']).to  eq [['conf1', ['p1', 'p2']],
                                            ['conf2', []],
                                            ['conf3', nil]]
      end
    end
  end
end
