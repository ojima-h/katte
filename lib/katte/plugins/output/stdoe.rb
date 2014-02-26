class Katte::Plugins::Output::Stdoe
  include Katte::Plugins::Output
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
