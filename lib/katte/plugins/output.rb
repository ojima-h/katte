class Katte::Plugins
  class Output < Base
    define_keyword :name
    index :name

    def out(node, output)
      output
    end
    def err(node, output)
      output
    end
  end
end
