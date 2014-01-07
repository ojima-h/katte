class Katte
  class Debug
    attr_accessor :out
    attr_accessor :err

    class Output
      def self.history
        @history ||= Queue.new
      end
      def self.open(node)
        reader_thread = nil

        out_r, out_w = IO.pipe
        err_r, err_w = IO.pipe

        history.push(node: node, out: out_r, err: err_r)

        yield out_w, err_w
      ensure
        [out_w, err_w].each {|w| w.close unless w.closed? }
      end
    end
  end
end
