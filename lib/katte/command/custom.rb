class Katte::Command
  class Custom
    class DSL
      def initialize(receiver, out, err)
        @receiver = receiver
        @out      = out
        @err      = err
      end

      %w(done fail).each do |method|
        define_method(method) do
          @receiver << method.to_sym
        end
      end
      def tag(t)
        @receiver << [:next, t]
      end

      def env      ; Katte.app.env         ; end
      def env_hash ; Katte.app.env.to_hash ; end

      def log(*args)
        @err.puts args
      end
    end

    def self.call(node)
      Enumerator.new {|receiver|
        node.open {|out, err|
          context = DSL.new(receiver, out, err)
          begin
            context.instance_eval(File.read(node.path), node.path)
          rescue => e
            err.puts e.to_s
            context.fail
          end
        }
      }
    end
  end
end
