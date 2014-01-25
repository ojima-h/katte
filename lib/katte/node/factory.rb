require 'pathname'
require 'katte/task_manager/default'
require 'katte/task_manager/sleeper'

class Katte::Node
  class Factory
    def self.path_pattern
      return @path_pattern if @path_pattern
      pattern_regexp = File.join(Katte.app.config.recipes_root, '(?<name>.+?)\.(?<ext>\w+)')
      @path_pattern = /^#{pattern_regexp}$/
    end

    def self.load(path)
      return unless FileTest.file? path
      return unless m = path_pattern.match(path)

      name, ext = m[:name], m[:ext]

      file_type = Katte::Plugins.file_type[ext]

      directive = file_type.parse(path)

      parents = directive['require']
      output  = directive['output'].map {|o| Katte::Plugins.output[o.to_sym]}
      period  = directive['period'].last || 'day'
      options = {}
      directive['option'].each {|x|
        x.split(',').each {|o|
          k, v = o.split('=')
          options[k.strip] = (v ? v.strip : true)
        }
      }

      params = {
        :name         => name,
        :path         => path,
        :parents      => parents,
        :file_type    => file_type,
        :output       => output,
        :period       => period,
        :task_manager => Katte::TaskManager::Default.instance,
        :options      => options,
      }

      if Katte.app.config.mode == 'test'
        params[:output] = [Katte::Plugins.output[:debug]]
      end

      if options['custom']
        params[:task_manager]  = Katte::TaskManager::Sleeper.instance
        params[:file_type]     = Katte::Plugins.file_type[:custom]
      end

      if Katte.app.options[:verbose] and not params[:output].map(&:name).include?(:stderr)
        params[:output] << Katte::Plugins.output[:stderr]
      end

      Katte::Node.new params
    end
  end
end
