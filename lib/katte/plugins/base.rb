class Katte::Plugins
  class Base
    def self.define_keyword(keyword)
      define_singleton_method(keyword) {|value|
        define_method(keyword) { value }
      }
    end

    def self.index(keyword)
      @index = keyword
    end

    def self.inherited(child)
      (@children ||= []) << child
    end
    def self.plugins
      @plugins ||= Hash[@children.map {|child|
        plugin = child.new
        [plugin.send(@index), plugin] if plugin.respond_to? @index
      }.compact]
    end
  end
end
