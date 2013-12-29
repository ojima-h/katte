require 'pathname'
require 'katte/node'

module Katte::Node::Factory
  class Base
    class << self
      def create(path)
        node_info = parse_path(path)
        return nil if node_info.nil?

        options = load_options(path, node_info[:command])

        Katte::Node.new(:name    => node_info[:name],
                        :path    => path,
                        :command => node_info[:command],
                        :period  => node_info[:period],
                        :options => options)
      end

      def parse_path(path)
        @pattern ||= Regexp.new('^(?<name>.+?)\.(?<period>\w+)\.(?<ext>\w+)$')
        m = @pattern.match(path)
        return nil if m.nil?

        name = m[:name].gsub(%r(^#{Katte.config.recipes_root}/), '')

        command = Katte.command_map(m[:ext])

        return {name: name, period: m[:period], command: command}
      end

      def load_options(path, command)
        comment_pattern   = /^#{command.comment_leading_chr}|^\s*$/
        directive_pattern = /^#{command.comment_leading_chr}\s*(?<key>\w+)\s*(?<value>.+)$/

        options = {}
        open(path) do |io|
          while line = io.gets
            line.chomp!
            break unless     comment_pattern.match(line)
            next  unless m = directive_pattern.match(line)

            key, value = m[:key], m[:value]

            options[key] ||= []
            options[key] << value
          end
          options
        end
      end
    end
  end
end
