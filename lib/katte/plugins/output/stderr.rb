class Katte::Plugins::Output
  class Stderr < Katte::Plugins::Output
    name :stderr

    def err(node, data)
      STDERR.puts data
      data
    end
  end
end
