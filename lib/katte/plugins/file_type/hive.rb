file_type :hive do
  extname 'sql'
  comment_by '--'
  command do |node|
    simple_exec node, 'hive', '-f', node.path
  end
end
