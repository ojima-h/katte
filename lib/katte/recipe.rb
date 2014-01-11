class Katte
  class Recipe
    attr_reader :name
    attr_reader :path
    attr_reader :file_type
    attr_reader :directive

    def initialize(params)
      @name      = params[:name]
      @path      = params[:path]
      @file_type = params[:file_type]
      @directive = params[:directive]
    end

    def self.load(path)
      return unless FileTest.file? path
      return unless m = path_pattern.match(path)

      file_type = Katte::Plugins.file_type[m[:ext]]

      directive = parse(path, file_type)

      new(:name      => m[:name],
          :path      => path,
          :file_type => file_type,
          :directive => directive)
    end

    def self.parse(path, file_type)
      comment_pattern   = /^#{file_type.comment_by}|^\s*$/
      directive_pattern = /^#{file_type.comment_by}\s*(?<key>\w+)\s*(?<value>.+)$/

      directive = {}
      open(path) do |io|
        while line = io.gets
          line.chomp!
          break unless     comment_pattern.match(line)
          next  unless m = directive_pattern.match(line)

          key, value = m[:key], m[:value]

          directive[key] ||= []
          directive[key] << value
        end
        directive
      end
    end

    def self.path_pattern
      return @path_pattern if @path_pattern

      pattern_regexp = File.join(Katte.app.config.recipes_root, '(?<name>.+?)\.(?<ext>\w+)')
      @path_pattern = /^#{pattern_regexp}$/
    end
  end
end
