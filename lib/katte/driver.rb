class Katte
  class Driver
    def self.run(nodes)
      core = Core.new(nodes)
      core.run
      core.summary
    end

    class Core
      attr_reader :summary
      def initialize(nodes, options = {})
        @nodes = nodes
        @nodes_list  = Hash[nodes.map {|node| [node.name, node.parents.length] }]
        @nodes_index = Hash[nodes.map {|node| [node.name, node] }]

        @queue = Queue.new

        @summary = {:success => [], :fail => [], :skip => []}
      end

      %w(done fail next skip finish).each do |method|
        define_method(method) do |*args|
          @queue.push [:"_#{method}", *args]
        end
      end

      def run
        return if @nodes_list.empty?

        run_nodes(@nodes.select{|n| n.parents.length.zero? })

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
        @nodes_list.delete(node.name)
        return finish if @nodes_list.empty?

        node.children.each do |child|
          @nodes_list[child.name] -= 1
          child.run(self) if @nodes_list[child.name].zero?
        end
      end
      def _fail(node, *args)
        @nodes_list.delete(node.name)
        node.descendants.each {|dec| @nodes_list.delete(dec.name) }

        finish if @nodes_list.empty?
      end
      def _next(node, child, *args)
        @nodes_list[child] -= 1
        @nodes_index[child].run(self) if @nodes_list[child].zero?
      end
      def _skip(node, *args)
        node.descendants.each {|dec| @nodes_list.delete(dec) }
        finish if @nodes_list.empty?
      end
    end
  end
end
