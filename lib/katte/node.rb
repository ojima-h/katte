require 'katte/node/factory'
require 'katte/node/loader'

class Katte
  class Node
    attr_reader :name
    attr_reader :path
    attr_reader :file_type
    attr_reader :period
    attr_reader :options

    def initialize(params)
      @params       = params
      @name         = params[:name]
      @path         = params[:path]
      @file_type    = params[:file_type]
      @output       = params[:output]
      @period       = params[:period]       || 'day'
      @task_manager = params[:task_manager] || Katte::TaskManager::Default.instance
      @options      = params[:options]      || {}
    end

    def parents
      @options['require'] || []
    end

    def open &proc
      @output.call(self, &proc)
    end

    def run(driver)
      return unless driver.filter.call(period: @period)

      unless @file_type
        Katte.app.logger.error("no file type specified for %s" % @name)
        return
      end

      @task_manager.run(self, driver)
    end
  end
end
