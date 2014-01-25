require 'find'

class Katte::Node
  class Loader
    class << self
      def load(root_path, factory = Katte::Node::Factory)
        Find.find(root_path).map(&factory.method(:load)).compact
      end
    end
  end
end
