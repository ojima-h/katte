require 'spec_helper'

class Katte
  describe Driver do
    before :all do
      @call_log = []
      callback = Proc.new {|node| @call_log << node.name}

      debug_plugin = Katte::Plugins.file_type[:debug]

      @nodes = []
      @nodes << Node.new(name: 'test_1', command: debug_plugin.command, options: {'callback' => [callback]})
      @nodes << Node.new(name: 'test_2', command: debug_plugin.command, options: {'require' => ['test_1'], 'callback' => [callback]})
      @nodes << Node.new(name: 'test_3', command: debug_plugin.command, options: {'require' => ['test_2'], 'callback' => [callback]})

      @graph = DependencyGraph.new(@nodes)
    end

    it 'excecute each node according to dependency graph' do
      driver = Driver.new(@graph)
      driver.run

      expect(@call_log).to eq %w(test_1 test_2 test_3)
    end

    it 'skip nodes when parent node failed' do
      call_log = []
      debug_plugin = Katte::Plugins.file_type[:debug]
      nodes = [ Node.new(name: 'test_1',
                         command: debug_plugin.command,
                         options: {
                           'callback' => [Proc.new{|node| raise Katte::Plugins::FileType::Debug::Abort}]
                         }),
                Node.new(name: 'test_2',
                         command: debug_plugin.command,
                         options: {
                           'require' => ['test_1'],
                           'callback' => [Proc.new{|node| call_log << node.name}],
                         }),
                Node.new(name: 'test_3',
                         command: debug_plugin.command,
                         options: {
                           'callback' => [Proc.new{|node| call_log << node.name}],
                         }),
              ]
      graph = DependencyGraph.new(nodes)
      driver = Driver.new(graph)

      driver.run

      expect(call_log).to eq ["test_3"]
    end
  end
end
