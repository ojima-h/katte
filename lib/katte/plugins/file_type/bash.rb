class Katte::Plugins::FileType::Bash
  include Katte::Plugins::FileType
  extname    'sh'
  comment_by '#'

  def execute(node)
    simple_exec(node, 'bash', node.path)
  end
end
