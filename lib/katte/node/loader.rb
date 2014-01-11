require 'find'
require 'katte/recipe'

class Katte::Node
  class Loader
    class << self
      def load(root_path)
        Find.find(root_path).map {|path|
          recipe = Katte::Recipe.load(path)
          Factory.create(recipe) if recipe
        }.compact
      end
    end
  end
end
