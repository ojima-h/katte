class Katte::Plugins::Node::Debug
  include Katte::Node::Base
  include Katte::Plugins::Node

  name 'debug'

  def run(driver)
    children.each {|child| driver.next(self, child.name) }
    driver.done(self)
  end
end
