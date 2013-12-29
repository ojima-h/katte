class Katte
  class Node
    attr_reader :name
    attr_reader :klass
    attr_reader :options

    def initialize(name, klass, options)
      @name  = name
      @klass = klass
      @options = options
    end

    def parents
      options['require'] || []
    end

    def execute
      @klass.execute(@name, @options)
    end
  end
end
