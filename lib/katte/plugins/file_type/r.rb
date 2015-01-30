class Katte::Plugins::FileType::R
  include Katte::Plugins::FileType
  extname    'R'
  comment_by '#'

  def execute(node)
    simple_exec(node, 'Rscript', node.path)
  end
end
