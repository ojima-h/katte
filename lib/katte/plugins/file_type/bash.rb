class Katte::Plugins::FileType
  class Bash < Katte::Plugins::FileType
    extname    'sh'
    comment_by '#'

    def execute(node)
      simple_exec(node, 'bash', node.path)
    end
  end
end
