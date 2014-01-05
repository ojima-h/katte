require 'katte/thread_manager'

class Katte
  class Driver
    def initialize(dependency_graph)
      @dependency_graph = dependency_graph

      @thread_manager = ThreadManager.new
      @thread_manager.run
    end

    def run_nodes(nodes)
      nodes.each {|node| node.run(@thread_manager, self) }
    end

    def done(node)
      next_nodes = @dependency_graph.done(node)
      return @thread_manager.stop if next_nodes.nil?

      run_nodes(next_nodes)
    end
    def fail(node)
      @dependency_graph.fail(node)
      @thread_manager.stop if @dependency_graph.nodes.empty?
    end

    def run
      return if @dependency_graph.empty?

      run_nodes(@dependency_graph.root)
      @thread_manager.join
    end
  end
end
