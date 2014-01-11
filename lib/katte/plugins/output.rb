class Katte::Plugins
  class Output < Base
    define_keyword :name
    index :name

    def out(node, stream)
      stream.each {|line| yield line }
    end
    def err(node, stream)
      stream.each {|line| yield line }
    end
  end
end
