class Katte::Plugins::FileType::Debug
  include Katte::Plugins::FileType

  extname :debug

  class Abort < StandardError; end

  def execute(node)
    node.options['callback'].each {|cb| cb.call(node) }
    return true
  rescue Abort => e
    return false
  end
end
