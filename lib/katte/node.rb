class Katte
  class Node
    attr_reader :name
    attr_reader :path
    attr_reader :command
    attr_reader :period
    attr_reader :options

    def initialize(params)
      @params  = params
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
      unless @command
        Katte.logger.error("no command specified for %s" % @name)
        return
      end

      @command.execute(@params)
    end
  end
end



