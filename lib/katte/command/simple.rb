class Katte::Command
  class Simple
    class << self
      def execute(options)
      end

      def comment_leading_chr
        '#'
      end

      def run(node, thread_manager, &callback)
        thread_manager.push {
          execute(node)
          callback.call(node)
        }
      end
    end
  end
end
