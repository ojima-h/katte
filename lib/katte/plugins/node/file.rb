class Katte::Plugins::Node
  class File_ < Katte::Plugins::Node
    name 'file'

    def add_child(node, *params)
    end

    def run(driver)
      driver.done(self)
    end
  end
end
