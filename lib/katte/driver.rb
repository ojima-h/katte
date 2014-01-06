class Katte
  class Driver
    attr_reader :filter
    def initialize(dependency_graph, options = {})
      @dependency_graph = dependency_graph

      @filter = options[:filter] || ->(_){ true }

      @queue = Queue.new
    end

    %w(done fail next finish).each do |method|
      define_method(method) do |*args|
        @queue.push [:"_#{method}", *args]
      end
    end

    def run
      return if @dependency_graph.empty?

      run_nodes(@dependency_graph.root)

      loop {
        method, *args = @queue.pop

        break if method == :_finish
        self.send(method, *args)
      }
    end

    private
    def run_nodes(nodes)
      nodes.each {|node| node.run(self) }
    end

    def _done(node, *args)
      next_nodes = @dependency_graph.done(node)
      return finish if @dependency_graph.empty?

      run_nodes(next_nodes) unless next_nodes.nil?
    end
    def _fail(node, *args)
      @dependency_graph.fail(node)
      finish if @dependency_graph.empty?
    end
    def _next(node, tag, *args)
      next_nodes = @dependency_graph.next(node, tag)
      run_nodes(next_nodes) unless next_nodes.nil?
    end
  end
end
