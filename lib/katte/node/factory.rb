require 'pathname'
require 'katte/thread_manager/default'
require 'katte/thread_manager/sleeper'
require 'katte/command/custom'

class Katte::Node
  class Factory
    class << self
      def create(recipe)
        output = Katte.app.find_plugin(:output, Katte.app.config.mode == 'test' ? :debug : recipe.directive['output'] || :file)

        params = {
          :name    => recipe.name,
          :path    => recipe.path,
          :command => recipe.file_type.command,
          :output  => output.command,
          :period  => recipe.directive['period'],
          :thread  => Katte::ThreadManager::Default.instance,
          :options => recipe.directive,
        }

        if recipe.directive['custom']
          params[:thread]  = Katte::ThreadManager::Sleeper.instance
          params[:command] = Katte::Command::Custom
        end

        Katte::Node.new params
      end
    end
  end
end
