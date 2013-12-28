require 'thread'

class Katte
  class ThreadManager
    attr_reader :threads
    def initialize(threads_num = 4)
      @queue = Queue.new
      @threads_num = threads_num
    end

    def run
      procedure = Proc.new { loop { @queue.pop.call rescue nil } }

      @threads = @threads_num.times.map { Thread.start &procedure }
    end

    def push &procedure
      @queue.push procedure
    end

    def stop
      @threads.each &:exit
    end
  end
end
