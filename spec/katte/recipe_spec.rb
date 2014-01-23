require 'spec_helper'
require 'tempfile'

class Katte
  describe Recipe do
    describe '.parse' do
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
        directive = Recipe.parse(@recipe_path, Katte::Plugins.file_type["sh"])

        expect(directive).to have_key 'require'
        expect(directive).to have_key 'option'

        expect(directive['require']).to eq ['recipe']
        expect(directive['option']).to  eq ['conf1', 'conf2', 'conf3']
      end
    end
  end
end
