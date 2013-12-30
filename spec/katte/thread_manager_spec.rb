require 'spec_helper'
require 'logger'
require 'stringio'

require 'katte/thread_manager'

class Katte
  describe ThreadManager do
    class Spy
      attr_reader :num_called
      def initialize
        @num_called     = 0
        @mutex          = Mutex.new
      end
      def call
        @mutex.synchronize { @num_called += 1 }
      end
    end

    it "execute procedures concurrently" do
      thread_manager = ThreadManager.new
      spy = Spy.new

      threads = thread_manager.run
      4.times { thread_manager.push { spy.call } }
      sleep 0.1

      expect(spy.num_called).to eq 4
    end

    it "ignores all exceptions" do
      logio = StringIO.new
      logger = Logger.new(logio)

      thread_manager = ThreadManager.new(4, logger)
      spy = Spy.new

      threads = thread_manager.run
      4.times { thread_manager.push { raise "Test thread_manager_spec" } }
      sleep 0.1

      expect(threads.count(&:alive?)).to eq 4

      logio.rewind
      logstr = logio.readlines.join
      expect(logstr).to match(/Test thread_manager_spec/)
    end

    describe "#stop" do
      it "kills all threads" do
        thread_manager = ThreadManager.new

        threads = thread_manager.run
        3.times { thread_manager.push { sleep } }
        Thread.start { sleep 0.1; thread_manager.stop }
        threads.each &:join
      end
    end
  end
end
