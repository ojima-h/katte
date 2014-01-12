require 'spec_helper'

class Katte::Plugins
  describe Output do
    before :all do
      klasses = 2.times.map {|i|
        Class.new(Katte::Plugins::Output) {|klass|
          name :"test_#{i}"
          attr_reader :result
          def out(node, stream)
            (@result ||= []) << stream.join
            stream
          end
        }
      }
      @plugins = klasses.map &:new
    end

    it "puts to all output plugins" do
      node = Katte::Node.new(output: @plugins)
      node.open {|out, err|
        out.puts "a"
      }

      @plugins.all? {|plugin|
        expect(plugin.result).to eq ["a\n"]
      }
    end
  end
end
