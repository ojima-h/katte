class Katte
  class Node
    attr_reader :path
    attr_reader :klass
    attr_reader :options

    def initialize(path, klass, options)
      @path  = path
      @klass = klass
      @options = options
    end

    def parents
      options['require']
    end

    def execute
      @klass.execute(@path, @options)
    end
  end
end
