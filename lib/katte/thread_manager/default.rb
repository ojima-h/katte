require 'katte/thread_pool'
class Katte
  class ThreadManager
    class Default
      def self.instance
        @instance ||= self.new
      end

      def initialize
        @thread_pool = ThreadPool.new
        @thread_pool.run
      end

      def run
        @thread_pool.push { yield }
      end
    end
  end
end
