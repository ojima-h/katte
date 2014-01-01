require 'katte/node'

class Katte
  class DependencyGraph
    attr_reader :nodes
    def initialize(nodes)
      build(nodes)

      @mutex = Mutex.new
    end

    def root
      @root_nodes
    end

    def empty?
      @nodes.nil? || @nodes.empty?
    end

    def done(node)
      @mutex.synchronize { _done(node) }
    end
    def fail(node)
      @mutex.synchronize { _delete(node.name) }
    end

    def descendants(nodes)
      next_nodes = nodes.map(&:name)
      descendant_nodes = []
      loop {
        next_nodes = next_nodes.map{|n| @dependency[n]}.flatten.compact
        descendant_nodes.append
      }
    end

    private
    def build(nodes)
      @nodes = {}

      @root_nodes = []
      @dependency = {}

      @parents_count = {}

      nodes.each do |node|
        @nodes[node.name] = node

        if node.parents.empty?
          @root_nodes << node
        else
          node.parents.each do |parent|
            @dependency[parent] ||= []
            @dependency[parent] << node.name
          end
        end

        @parents_count[node.name] = node.parents.length
      end
    end

    def _done(node)
      @nodes.delete(node.name)

      return nil if @nodes.empty?

      children = @dependency.delete(node.name)
      return [] if children.nil?

      children.map {|child|
        @parents_count[child] -= 1

        next if @parents_count[child] > 0

        @parents_count.delete(child)
        @nodes[child]
      }.compact
    end

    def _delete(node_name)
      @nodes.delete(node_name)
      @parents_count.delete(node_name)
      children = @dependency.delete(node_name)

      return if children.nil?
      children.each {|child| _delete(child) }
    end
  end
end
