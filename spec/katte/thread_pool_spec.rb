require 'spec_helper'
require 'logger'
require 'stringio'

class Katte
  describe ThreadPool do
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
      thread_pool = ThreadPool.new
      spy = Spy.new

      threads = thread_pool.run
      4.times { thread_pool.push { spy.call } }
      sleep 0.1

      expect(spy.num_called).to eq 4
    end

    it "ignores all exceptions" do
      logio = StringIO.new
      logger = Logger.new(logio)

      thread_pool = ThreadPool.new(4, logger)
      spy = Spy.new

      threads = thread_pool.run
      4.times { thread_pool.push { raise "Test thread_pool_spec" } }
      sleep 0.1

      expect(threads.count(&:alive?)).to eq 4

      logio.rewind
      logstr = logio.readlines.join
      expect(logstr).to match(/Test thread_pool_spec/)
    end
  end
end
