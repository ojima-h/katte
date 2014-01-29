require 'katte/node/factory'

class Katte
  class Node
    %w(name path parents file_type output period task_manager options children).each {|attr|
      attr_accessor attr
    }

    def initialize(params)
      @name         = params[:name]
      @path         = params[:path]
      @parents      = params[:parents]      || []
      @file_type    = params[:file_type]
      @output       = params[:output]       || []
      @period       = params[:period]       || 'day'
      @task_manager = params[:task_manager] || Katte::TaskManager::Default.instance
      @options      = params[:options]      || {}

      @children     = []
    end

    def add_child(node)
      @children << node
    end

    def open
      out_r, out_w = IO.pipe
      err_r, err_w = IO.pipe

      result = yield out_w, err_w

      [out_w, err_w].each {|io| io.close unless io.closed? }
      out_a, err_a = out_r.to_a.join, err_r.to_a.join
      [out_r, err_r].each {|io| io.close unless io.closed? }

      @output.reduce(out_a) {|stream, o| o.out(self, stream) }
      @output.reduce(err_a) {|stream, o| o.err(self, stream) }

      result
    ensure
      [out_r, out_w, err_r, err_w].each {|io| io.close unless io.closed? }
    end

    def run(driver)
      unless driver.filter.call(period: @period)
        driver.skip(self)
        return
      end

      unless @file_type
        Katte.app.logger.error("no file type specified for %s" % @name)
        return
      end

      @task_manager.run(self, driver)
    end
    def descendants
      Enumerator.new {|enum| _descendants(enum) }
    end
    def _descendants(enum)
      children.each {|node|
        enum << node
        node._descendants(enum)
      }
      enum
    end
  end
end
