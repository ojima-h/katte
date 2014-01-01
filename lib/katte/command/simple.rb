class Katte::Command
  class Simple
    class << self
      def execute(options)
        true
      end

      def comment_leading_chr
        '#'
      end

      def run(node, thread_manager, &callback)
        thread_manager.push {
          result = execute(node)
          callback.call(node, result)
        }
      end
    end
  end
end
