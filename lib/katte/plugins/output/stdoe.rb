class Katte::Plugins::Output
  class Stdoe < Katte::Plugins::Output
    name :stdoe

    def out(node, data)
      STDIN.puts data
      data
    end

    def err(node, data)
      STDERR.puts data
      data
    end
  end
end
