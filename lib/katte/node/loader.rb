require 'find'

require 'katte/node/factory'

class Katte::Node
  class Loader
    class << self
      def load
        nodes = []
        Find.find(Katte.config.recipes_root) do |path|
          next unless FileTest.file? path
          nodes << Factory.create(path)
        end
        nodes
      end
    end
  end
end
