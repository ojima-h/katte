class Katte::Command
  class Simple
    class << self
      def execute(options)
        true
      end

      def comment_leading_chr
        '#'
      end

      def run(node, thread_manager, driver)
        thread_manager.push {
          result = execute(node)

          if result
            driver.done(node)
          else
            driver.fail(node)
          end
        }
      end
    end
  end
end
