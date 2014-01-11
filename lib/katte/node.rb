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

    def open
      out_r, out_w = IO.pipe
      err_r, err_w = IO.pipe

      yield out_w, err_w
      [out_w, err_w].each {|io| io.close unless io.closed? }

      out_a, err_a = out_r.to_a, err_r.to_a
      [out_r, err_r].each {|io| io.close unless io.closed? }

      @output.reduce(out_a) {|stream, o| o.out(self, stream) }
      @output.reduce(err_a) {|stream, o| o.err(self, stream) }
    ensure
      [out_r, out_w, err_r, err_w].each {|io| io.close unless io.closed? }
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
