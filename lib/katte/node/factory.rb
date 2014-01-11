require 'pathname'
require 'katte/task_manager/default'
require 'katte/task_manager/sleeper'

class Katte::Node
  class Factory
    class << self
      def create(recipe)
        output = Katte::Plugins.output[Katte.app.config.mode == 'test' ? :debug : recipe.directive['output'] || :file]

        params = {
          :name         => recipe.name,
          :path         => recipe.path,
          :command      => recipe.file_type.command,
          :output       => output.command,
          :period       => recipe.directive['period'],
          :task_manager => Katte::TaskManager::Default.instance,
          :options      => recipe.directive,
        }

        if recipe.directive['custom']
          params[:task_manager]  = Katte::TaskManager::Sleeper.instance
          params[:command]       = Katte::Plugins.file_type[:custom].command
        end

        Katte::Node.new params
      end
    end
  end
end
