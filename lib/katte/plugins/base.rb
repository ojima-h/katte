module Katte::Plugins
  module Base
    def class_methods
      @class_methods ||= Module.new
    end
    private :class_methods

    def included(klass)
      klass.extend class_methods
    end

    def index(keyword = nil)
      return @index unless keyword
      @index = keyword
    end
    def define_keyword(keyword)
      klass = self

      class_methods.send(:define_method, keyword) {|value|
        define_method(keyword) { value }

        if klass.index == keyword
          klass.register(value, self.new)
        end
      }
    end

    def plugins
      @plugins ||= {}
    end
    def register(index, plugin)
      plugins[index] = plugin
    end
    def find(index)
      plugins[index]
    end
  end
end
