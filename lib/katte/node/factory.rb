require 'pathname'
require 'katte/thread_manager/default'
require 'katte/thread_manager/sleeper'
require 'katte/command/custom'
require 'katte/recipe_parser'

class Katte::Node
  class Factory
    class << self
      def create(path)
        return nil unless FileTest.file? path

        name, ext = parse_path(path).tap {|x|
          return nil if x.nil?
          break x[:name], x[:ext]
        }
        file_type_plugin = Katte.app.find_plugin(:file_type, ext)

        options = Katte::RecipeParser.new(file_type_plugin.comment).parse(path)

        output_plugin = Katte.app.find_plugin(:output, Katte.app.config.mode == 'test' ? :debug : options['output'] || :file)

        params = {
          :name    => name,
          :path    => path,
          :command => file_type_plugin.command,
          :output  => output_plugin.command,
          :period  => options.delete('period'),
          :thread  => Katte::ThreadManager::Default.instance,
          :options => options,
        }

        if options['custom']
          params[:thread]  = Katte::ThreadManager::Sleeper.instance
          params[:command] = Katte::Command::Custom
        end

        Katte::Node.new params
      end

      def parse_path(path)
        @pattern ||= Regexp.new('^(?<name>.+?)\.(?<ext>\w+)$')
        m = @pattern.match(path)
        return nil if m.nil?

        return {
          :name => m[:name].gsub(%r(^#{Katte.app.config.recipes_root}/), ''),
          :ext  => m[:ext]
        }
      end
    end
  end
end
