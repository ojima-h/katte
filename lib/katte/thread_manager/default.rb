class Katte
  class ThreadManager
    class Default
      def self.run(thread_manager)
        thread_manager.push { yield }
      end
    end
  end
end
