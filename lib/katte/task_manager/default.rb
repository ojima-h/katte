require 'katte/task_manager/thread_pool'
class Katte
  class TaskManager
    class Default
      def self.instance
        @instance ||= self.new
      end

      def run(node, driver)
        @thread_pool.push {
          result = node.command.call(node)
          result ? driver.done(node) : driver.fail(node)
        }
      end

      private
      def initialize
        @thread_pool = ThreadPool.new
        @thread_pool.run
      end
    end
  end
end
