module Katte::Recipe::FileType
  class <<self
    def table
      @table ||= {}
    end
    private :table
      
    def register(file_type, extname = nil)
      extname ||= file_type.extname
      table[extname] = file_type
    end

    def find(extname)
      table[extname] || Katte::Plugins::FileType.find(extname)
    end
    def register_builtin_file_types
      Dir[File.expand_path('../plugins/file_type/*.rb', __FILE__)].each {|p|
        require p
        name = File.basename(p, ".rb")
        klass = "katte/plugins/file_type/#{name}".camelize.constantize
      }
      register(Katte::Plugins::FileType::Bash.new)
      register(Katte::Plugins::FileType::Debug.new)
      register(Katte::Plugins::FileType::Hive.new)
      register(Katte::Plugins::FileType::R.new)
      register(Katte::Plugins::FileType::Ruby.new)
    end
  end
end
