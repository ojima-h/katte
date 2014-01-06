require 'pathname'
require 'katte/node'
require 'katte/thread_manager/default'
require 'katte/thread_manager/sleeper'
require 'katte/command/custom'

class Katte::Node
  class Factory
    class << self
      def create(path)
        return nil unless FileTest.file? path

        name, ext = parse_path(path).tap {|x|
          return nil if x.nil?
          break x[:name], x[:ext]
        }
        file_type = Katte.file_type(ext)
        command   = Katte.command(ext)

        options = file_type.load_options(path)

        params = {
          :name    => name,
          :path    => path,
          :command => command,
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
          :name => m[:name].gsub(%r(^#{Katte.config.recipes_root}/), ''),
          :ext  => m[:ext]
        }
      end
    end
  end
end
