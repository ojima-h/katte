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
          :file_type    => recipe.file_type,
          :output       => output,
          :period       => recipe.directive['period'],
          :task_manager => Katte::TaskManager::Default.instance,
          :options      => recipe.directive,
        }

        if recipe.directive['custom']
          params[:task_manager]  = Katte::TaskManager::Sleeper.instance
          params[:file_type]     = Katte::Plugins.file_type[:custom]
        end

        Katte::Node.new params
      end
    end
  end
end
