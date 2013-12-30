require 'katte/thread_manager'

class Katte
  class Driver
    def initialize(graph)
      @graph = graph

      @thread_manager = ThreadManager.new
      @thread_manager.run
    end

    def execute_nodes(nodes)
      nodes.each {|node|
        @thread_manager.push {
          node.execute
          callback(node)
        }
      }
    end

    def callback(node)
      next_nodes = @graph.done(node)

      if next_nodes.nil?
        @thread_manager.stop
      else
        execute_nodes(next_nodes)
      end
    end

    def run
      execute_nodes(@graph.root)
      @thread_manager.join
    end
  end
end
