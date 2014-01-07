class Katte::Command
  class Custom
    class DSL
      def initialize(receiver)
        @receiver = receiver
      end

      %w(done fail).each do |method|
        define_method(method) do
          @receiver << method.to_sym
        end
      end
      def tag(t)
        @receiver << [:next, t]
      end
    end

    def self.call(node)
      Enumerator.new {|receiver|
        DSL.new(receiver).instance_eval(File.read(node.path), node.path)
      }
    end
  end
end
