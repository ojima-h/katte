file_type :shell do
  extname 'sh'
  comment_by '#'
  command do |node|
    simple_exec node, 'bash', node.path
  end
end
