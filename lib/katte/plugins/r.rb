file_type :R do
  extname 'R'
  comment_by '#'
  command do |node|
    simple_exec node, 'Rscript', node.path
  end
end
