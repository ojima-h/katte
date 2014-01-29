require 'spec_helper'

class Katte
  describe Driver do
    it 'excecute each node according to dependency graph' do
      call_log = []
      callback = Proc.new {|node| call_log << node.name}

      debug_plugin = Katte::Plugins.file_type[:debug]

      factory = Katte::Node::Factory.new
      factory.create(:name      => 'test_1',
                     :file_type => debug_plugin,
                     :options   => {'callback' => [callback]})
      factory.create(:name      => 'test_2',
                     :file_type => debug_plugin,
                     :parents   => ['test_1'],
                     :options   => {'callback' => [callback]})
      factory.create(:name      => 'test_3',
                     :file_type => debug_plugin,
                     :parents   => ['test_2'],
                     :options   => {'callback' => [callback]})

      driver = Driver.new(factory.nodes)
      driver.run

      expect(call_log).to eq %w(test_1 test_2 test_3)
    end

    it 'skip nodes when parent node failed' do
      call_log = []
      callback = Proc.new {|node| call_log << node.name }
      failure_callback = Proc.new{|node| raise Katte::Plugins::FileType::Debug::Abort}
      debug_plugin = Katte::Plugins.file_type[:debug]

      factory = Katte::Node::Factory.new
      factory.create(:name      =>  'test_1',
                     :file_type => debug_plugin,
                     :options   => {'callback' => [failure_callback]})
      factory.create(:name      => 'test_2',
                     :file_type => debug_plugin,
                     :parents   => ['test_1'],
                     :options   => {'callback' => [callback]})
      factory.create(:name      => 'test_3',
                     :file_type => debug_plugin,
                     :options   => {'callback' => [callback]})

      driver = Driver.new(factory.nodes)
      driver.run

      expect(call_log).to eq ["test_3"]
    end
  end
end
