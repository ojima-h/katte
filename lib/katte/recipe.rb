class Katte
  class Recipe
    attr_accessor :name
    attr_accessor :path
    attr_accessor :file_type
    attr_accessor :parents
    attr_accessor :output
    attr_accessor :period
    attr_accessor :options

    def initialize(params)
      @name      = params[:name]
      @path      = params[:path]
      @file_type = params[:file_type]
      @parents   = params[:parents]
      @output    = params[:output]  || []
      @period    = params[:period]
      @options   = params[:options] || {}
    end

    def self.load(path)
      return unless FileTest.file? path
      return unless m = path_pattern.match(path)

      file_type = Katte::Plugins.file_type[m[:ext]]

      directive = parse(path, file_type)

      parents = directive['require']
      output  = directive['output'].map {|x|
        x.split(',').map(&:strip).map(&:to_sym)
      }.flatten
      period  = directive['period'].last || 'day'

      options = {}
      directive['option'].each {|x|
        x.split(',').each {|o|
          k, v = o.split('=')
          options[k.strip] = (v ? v.strip : true)
        }
      }

      new(:name      => m[:name],
          :path      => path,
          :file_type => file_type,
          :parents   => parents,
          :output    => output,
          :period    => period,
          :options   => options,)
    end

    def self.parse(path, file_type)
      comment_pattern   = /^#{file_type.comment_by}|^\s*$/
      directive_pattern = /^#{file_type.comment_by}\s*(?<key>\w+):\s*(?<value>.+)$/

      directive = Hash.new {|h,k| h[k] = [] }
      open(path) do |io|
        while line = io.gets
          line.chomp!
          break unless     comment_pattern.match(line)
          next  unless m = directive_pattern.match(line)

          key, value = m[:key], m[:value]

          directive[key] << value.strip
        end
      end
      directive
    end

    def self.path_pattern
      return @path_pattern if @path_pattern

      pattern_regexp = File.join(Katte.app.config.recipes_root, '(?<name>.+?)\.(?<ext>\w+)')
      @path_pattern = /^#{pattern_regexp}$/
    end
  end
end
