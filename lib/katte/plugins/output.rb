class Katte::Plugins
  class Output < Base
    define_keyword :name
    index :name

    def out(node, stream)
      stream
    end
    def err(node, stream)
      stream
    end
  end
end
