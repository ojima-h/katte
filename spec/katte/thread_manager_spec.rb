require 'spec_helper'
require 'katte/thread_manager'

class Katte
  describe ThreadManager do
    class Spy
      attr_reader :num_called
      def initialize(thread_manager)
        @thread_manager = thread_manager
        @num_called     = 0
        @mutex          = Mutex.new
      end
      def call
        @mutex.synchronize { @num_called += 1 }
      end
    end

    it "execute procedures concurrently" do
      thread_manager = ThreadManager.new
      spy = Spy.new(thread_manager)

      threads = thread_manager.run
      4.times { thread_manager.push { spy.call } }
      sleep 0.2

      expect(spy.num_called).to equal(4)
    end

    it "ignores all exceptions" do
      thread_manager = ThreadManager.new
      spy = Spy.new(thread_manager)

      threads = thread_manager.run
      4.times { thread_manager.push { raise :error } }
      sleep 0.2

      expect(threads.count(&:alive?)).to equal(4)
    end

    describe "#stop" do
      it "kills all threads" do
        thread_manager = ThreadManager.new

        threads = thread_manager.run
        3.times { thread_manager.push { sleep -1 } }
        Thread.start { sleep 0.2; thread_manager.stop }
        threads.each &:join
      end
    end
  end
end
