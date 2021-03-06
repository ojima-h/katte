require 'katte/node/base'
require 'katte/recipe/node_factory'
require 'katte/thread_pool'

module Katte::Recipe
  class Node
    include Katte::Node::Base

    %w(name path file_type output period options).each {|attr|
      attr_accessor attr
    }

    def initialize(params)
      @name         = params[:name]
      @path         = params[:path]
      @requires     = params[:require]
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

      result = yield out_w, err_w

      [out_w, err_w].each {|io| io.close unless io.closed? }
      out_a, err_a = out_r.to_a.join, err_r.to_a.join
      [out_r, err_r].each {|io| io.close unless io.closed? }

      Katte.app.logger.warn("#{self.name} -- result is empty") if out_a.empty?

      @output.reduce(out_a) {|stream, o| o.out(self, stream) }
      @output.reduce(err_a) {|stream, o| o.err(self, stream) }

      result
    ensure
      [out_r, out_w, err_r, err_w].each {|io| io.close unless io.closed? }
    end

    def run(driver)
      unless @file_type
        Katte.app.logger.error("no file type specified for %s" % @name)
        return
      end

      Katte::ThreadPool.instance.push {
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
