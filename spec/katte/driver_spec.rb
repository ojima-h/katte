require 'spec_helper'

require 'katte/driver'
require 'katte/node'
require 'katte/dependency_graph'
require 'katte/command/test'

class Katte
  describe Driver do
    before :all do
      @call_log = []
      callback = Proc.new {|node| @call_log << node.name}

      @nodes = []
      @nodes << Node.new(name: 'test_1', command: Katte::Command::Test, options: {'callback' => [callback]})
      @nodes << Node.new(name: 'test_2', command: Katte::Command::Test, options: {'require' => ['test_1'], 'callback' => [callback]})
      @nodes << Node.new(name: 'test_3', command: Katte::Command::Test, options: {'require' => ['test_2'], 'callback' => [callback]})

      @graph = DependencyGraph.new(@nodes)
    end
    it 'excecute each node according to dependency graph' do
      driver = Driver.new(@graph)
      driver.run

      expect(@call_log).to eq %w(test_1 test_2 test_3)
    end
  end
end
