class Katte::Plugins::FileType
  class Hive < Katte::Plugins::FileType
    extname    'sql'
    comment_by '--'

    def execute(node)
      simple_exec(node, 'hive', '-f', node.path)
    end
  end
end
