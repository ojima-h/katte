class Katte::Plugins::FileType
  class R < Katte::Plugins::FileType
    extname    'R'
    comment_by '#'

    def execute(node)
      simple_exec(node, 'Rscirpt', node.path)
    end
  end
end
