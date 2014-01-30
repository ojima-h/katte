class Katte::Plugins::Node
  class Debug < Katte::Plugins::Node
    name 'debug'

    def add_child(node, *params)
      children << node
    end

    def run(driver)
      children.each {|child| driver.next(self, child.name) }
      driver.done(self)
    end
  end
end
