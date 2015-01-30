module Katte::Node
  module Base
    class AbstractNodeException < Exception; end

    def name
      raise AbstractNodeException, "method #name must be implemented"
    end
    def requires
      @requires ||= []
    end

    # execution filter
    # return whether this node to run
    def run?
      false
    end
    def run(driver)
      driver.skip(self)
    end
    
    # accessor for children
    def children
      @children ||= []
    end
    def add_child(node, *params)
      children << node
    end

    # accessor for parents
    def parents
      @parents ||= []
    end
    def add_parent(node, *params)
      parents << node
    end

    def descendants
      Enumerator.new {|enum| _descendants(enum) }
    end
    def _descendants(enum)
      children.each {|node|
        enum << node
        node._descendants(enum)
      }
      enum
    end
  end
end
