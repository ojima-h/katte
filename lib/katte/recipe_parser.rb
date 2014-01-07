class Katte
  class RecipeParser
    def initialize(comment_chr = '#')
      @comment_chr = comment_chr || '#'
    end

    def parse(path)
      comment_pattern   = /^#{@comment_chr}|^\s*$/
      directive_pattern = /^#{@comment_chr}\s*(?<key>\w+)\s*(?<value>.+)$/

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
