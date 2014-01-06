require 'find'

require 'katte/node/factory'

class Katte::Node
  class Loader
    class << self
      def load(root_path)
        Find.find(root_path).map {|path|
          Factory.create(path) if FileTest.file? path
        }.compact
      end
    end
  end
end




