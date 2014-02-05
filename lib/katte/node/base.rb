class Katte
  class Node
    module Base
      def add_child(node, *params)
        (@children ||= []) << node
      end
      def add_parent(node, *params)
        (@parents ||= []) << node
      end
    end
  end
end
