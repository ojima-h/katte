class Katte::Command
  class Custom
    module DSL
      %w(done fail).each do |method|
        define_method(method) do
          Fiber.yield method.to_sym
        end
      end
      def tag(t)
        Fiber.yield :next, t
      end
    end

    def self.execute(node)
      context = Object.new
      context.extend DSL
      Fiber.new { context.instance_eval(File.read(node.path), node.path) }
    end
  end
end
