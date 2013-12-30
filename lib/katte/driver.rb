require 'katte/thread_manager'

class Katte
  class Driver
    def initialize(dependency_graph)
      @dependency_graph = dependency_graph

      @thread_manager = ThreadManager.new
      @thread_manager.run
    end

    def execute_nodes(nodes)
      nodes.each {|node| node.run(@thread_manager, &callback) }
    end

    def callback
      @callback ||= Proc.new {|node|
        next_nodes = @dependency_graph.done(node)

        if next_nodes.nil?
          @thread_manager.stop
        else
          execute_nodes(next_nodes)
        end
      }
    end

    def run
      return if @dependency_graph.empty?
      execute_nodes(@dependency_graph.root)
      @thread_manager.join
    end
  end
end
