require 'thread'

class Katte
  class ThreadPool
    attr_reader :threads
    def initialize(threads_num = 4, logger = Katte.app.logger)
      @queue         = Queue.new
      @threads_num   = threads_num
      @logger        = logger
    end

    def run
      procedure = Proc.new {
        loop {
          begin
            @queue.pop.call
          rescue => e
            @logger.error(e)
          end
        }
      }
      @threads ||= @threads_num.times.map { Thread.start &procedure }
    end

    def push &procedure
      @queue.push procedure
    end

    def stop
      @threads.each &:kill
    end

    def join
      @threads.each {|t| t.join}
    end
  end
end
