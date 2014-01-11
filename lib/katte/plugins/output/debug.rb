class Katte::Plugins::Output
  class Debug < Katte::Plugins::Output
    name :debug

    def history
      @history ||= Queue.new
    end

    def out(node, stream)
      history.push(node: node, out: stream.to_enum)

      stream
    end
  end
end



