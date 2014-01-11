class Katte
  class TaskManager
    class Sleeper
      attr_reader :threads

      def self.instance
        @instance ||= self.new
      end

      def run(node, driver)
        @threads << Thread.start {
          node.file_type.execute(node).each do |message, *args|
            driver.send(message, node, *args)
            break if [:done, :fail].any? {|m| m == message }
          end
        }
      end

      private
      def initialize
        @threads = []
      end
    end
  end
end
