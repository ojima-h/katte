class Katte::Plugins::Output
  class Debug < Katte::Plugins::Output
    name :debug

    def history
      @history ||= Queue.new
    end

    def out(node, data)
      history.push(node: node, out: data)

      data
    end
  end
end



