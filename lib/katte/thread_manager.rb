require 'thread'

class Katte
  class ThreadManager
    attr_reader :threads
    def initialize(threads_num = 4, logger = Katte.logger)
      @queue         = Queue.new
      @message_queue = Queue.new
      @threads_num   = threads_num
      @logger        = logger
    end

    def run
      @master_thread ||= Thread.start {
        case @message_queue.pop
        when :exit then @threads.each &:kill
        end
      }

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
      @message_queue.push :exit
    end

    def join
      @threads.each {|t| t.join}
    end
  end
end
