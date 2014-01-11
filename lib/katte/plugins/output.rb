class Katte::Plugins
  class Output < Base
    define_keyword :name
    index :name

    def command
      @command ||= method(:call)
    end
  end
end
