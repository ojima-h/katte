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
      @period  = params[:period]  || 'day'
      @thread  = params[:thread]  || Katte::ThreadManager::Default.instance
      @options = params[:options] || {}
    end

    def parents
      @options['require'] || []
    end

    def run(driver)
      unless @command
        Katte.logger.error("no command specified for %s" % @name)
        return
      end

      @thread.run do
        result = @command.execute(self)

        result ? driver.done(self) : driver.fail(self)
      end
    end
  end
end
