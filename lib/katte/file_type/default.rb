class Katte
  class FileType
    class Default
      class << self
        def comment_leading_chr
          '#'
        end

        def load_options(path)
          comment_pattern   = /^#{comment_leading_chr}|^\s*$/
          directive_pattern = /^#{comment_leading_chr}\s*(?<key>\w+)\s*(?<value>.+)$/

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
  end
end
