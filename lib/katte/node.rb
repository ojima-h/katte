require 'katte/node/base'
require 'katte/node/factory'
require 'katte/thread_pool'

class Katte
  class Node
    include Node::Base
    %w(name path file_type output period options parents children).each {|attr|
      attr_accessor attr
    }

    def initialize(params)
      @name         = params[:name]
      @path         = params[:path]
      @file_type    = params[:file_type]
      @output       = params[:output]       || []
      @period       = params[:period]       || 'day'
      @options      = params[:options]      || {}

      @parents      = []
      @children     = []
    end

    def open
      out_r, out_w = IO.pipe
      err_r, err_w = IO.pipe

      oe = {}
      t = Thread.new(oe) {|oe|
        oe[:out] = out_r.to_a.join
        oe[:err] = err_r.to_a.join
        [out_r, err_r].each {|io| io.close unless io.closed? }
      }

      result = yield out_w, err_w
      [out_w, err_w].each {|io| io.close unless io.closed? }

      t.join

      Katte.app.logger.warn("#{self.name} -- result is empty") if oe[:out].empty?

      @output.reduce(oe[:out]) {|stream, o| o.out(self, stream) }
      @output.reduce(oe[:err]) {|stream, o| o.err(self, stream) }

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

      ThreadPool.instance.push {
        Katte.app.logger.info("[start] #{self.name}")
        result = file_type.execute(self)
        Katte.app.logger.info(sprintf("[%s] #{self.name}", (result ? "success" : "fail")))

        result ? driver.done(self) : driver.fail(self)
      }
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
