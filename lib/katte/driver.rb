class Katte
  class Driver
    def initialize(dependency_graph)
      @dependency_graph = dependency_graph

      @queue = Queue.new
    end

    def run_nodes(nodes)
      nodes.each {|node| node.run(self) }
    end

    def done(node)
      next_nodes = @dependency_graph.done(node)
      return @queue.push(:done) if next_nodes.nil?

      run_nodes(next_nodes)
    end
    def fail(node)
      @dependency_graph.fail(node)
      @queue.push(:done) if @dependency_graph.nodes.empty?
    end

    def run
      return if @dependency_graph.empty?

      run_nodes(@dependency_graph.root)

      loop { break if @queue.pop == :done }
    end
  end
end
