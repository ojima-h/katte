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

      def env      ; Katte.env         ; end
      def env_hash ; Katte.env.to_hash ; end

      def log(*args)
        @err.puts args
      end
    end

    def self.call(node)
      Katte::Command.open(node) {|out, err|
        Enumerator.new {|receiver|
          DSL.new(receiver, out, err).instance_eval(File.read(node.path), node.path)
        }
      }
    end
  end
end
