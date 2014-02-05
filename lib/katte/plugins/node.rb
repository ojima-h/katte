class Katte::Plugins
  class Node < Base
    define_keyword :name
    index :name

    def requires; @requires ||= []; end
    def parents ; @parents  ||= []; end
    def children; @children ||= []; end

    def add_child(node)
    end

    def run(driver)
    end
  end
end
