file_type :ruby do
  extname 'rb'
  comment_by '#'
  command do |node|
    simple_exec node, 'ruby', node.path
  end
end
