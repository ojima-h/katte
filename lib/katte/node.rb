class Katte
  class Node
    attr_reader :name
    attr_reader :path
    attr_reader :command
    attr_reader :period
    attr_reader :options

    def initialize(params)
      @name    = params[:name]
      @path    = params[:path]
      @command = params[:command]
      @period  = params[:period]
      @options = params[:options] || {}
    end

    def parents
      @options['require'] || []
    end

    def execute
      @command.execute(@name, @options)
    end
  end
end
