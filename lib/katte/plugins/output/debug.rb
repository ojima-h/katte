output :debug do
  command do |node, &proc|
    Debug::Output.open(node, &proc)
  end
end
