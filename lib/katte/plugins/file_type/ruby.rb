class Katte::Plugins::FileType::Rubyn
  include Katte::Plugins::FileType
  extname    'rb'
  comment_by '#'

  def execute(node)
    simple_exec(node, 'ruby', node.path)
  end
end
