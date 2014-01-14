class Katte::Plugins::Output
  class Stdio < Katte::Plugins::Output
    name :stdio

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
