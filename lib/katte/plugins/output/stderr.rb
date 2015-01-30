class Katte::Plugins::Output::Stderr
  include Katte::Plugins::Output
  name :stderr

  def err(node, data)
    STDERR.puts data
    data
  end
end
