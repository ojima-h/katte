require 'pathname'
require 'katte/task_manager/default'
require 'katte/task_manager/sleeper'

class Katte::Node
  class Factory
    def self.create(recipe)
      output = (recipe.output || [:file]).map {|type|
        Katte::Plugins.output[type]
      }.compact

      params = {
        :name         => recipe.name,
        :path         => recipe.path,
        :parents      => recipe.parents,
        :file_type    => recipe.file_type,
        :output       => output,
        :period       => recipe.period || 'day',
        :task_manager => Katte::TaskManager::Default.instance,
        :options      => recipe.options,
      }

      if Katte.app.config.mode == 'test'
        params[:output] = [Katte::Plugins.output[:debug]]
      end

      if recipe.options['custom']
        params[:task_manager]  = Katte::TaskManager::Sleeper.instance
        params[:file_type]     = Katte::Plugins.file_type[:custom]
      end

      Katte::Node.new params
    end
  end
end
