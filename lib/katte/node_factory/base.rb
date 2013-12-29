require 'katte/node'

module Katte::NodeFactory
  class Base
    class << self
      def execute
      end

      def comment_pattern
        @comment_pattern   ||= Regexp.new('^#|^\s*$')
      end
      def directive_pattern
        @directive_pattern ||= Regexp.new('^#\s*(?<key>\w+)\s*(?<value>.+)$')
      end

      def parse_directive line
        m = directive_pattern.match(line)

        return m[:key], m[:value]
      end

      def parse(name)
        options = {}
        path = File.join(Katte.config.recipes_root, name)

        open(path) do |io|
          while line = io.gets
            line.chomp!
            break unless line =~ comment_pattern
            next  unless line =~ directive_pattern

            key, value = parse_directive(line)

            options[key] ||= []
            options[key] << value
          end
        end

        Katte::Node.new(name, self, options)
      end
    end
  end
end
