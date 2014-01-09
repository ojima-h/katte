require 'spec_helper'
require 'tempfile'

class Katte
  describe Plugins do
    describe 'filetype' do
      before :all do
        @path = Tempfile.open('plugin_sample.rb') do |tf|
          tf.print <<-EOF
file_type :shell do
  extname    'sh'
  comment_by '#'

  command do |node|
    simple_exec('bash', node.path)
  end
end
        EOF
          tf.path
        end
      end
      after(:all) { File.delete(@path) }

      it "load plugin definition DSL" do
        plugin = Plugins.load(@path)

        expect(plugin.name   ).to eq :shell
        expect(plugin.comment).to eq '#'
        expect(plugin.extname).to eq 'sh'
        expect(plugin.command).to be_respond_to :call
      end
    end
    describe 'output' do
      before :all do
        @path = Tempfile.open('plugin_sample.rb') do |tf|
          tf.print <<-EOF
output :plugins_spec do
  command do |node, &proc|
    read, write = IO.pipe
    log = File.open('/dev/null')
    Fiber.yield read

    proc.call(write, log)

    [write, log].each {|o| o.close unless o.closed? }
  end
end
        EOF
          tf.path
        end
      end
      after(:all) {
        File.delete(@path)
      }

      it "load plugin definition DSL" do
        plugin = Plugins.load(@path)

        expect(plugin.name).to eq :plugins_spec

        writer = nil
        f = Fiber.new {
          plugin.command.call(nil) do |w, l|
            writer = w
            w.puts "test"
          end
        }
        reader = f.resume
        f.resume

        expect(reader.gets).to eq "test\n"
        expect(writer).to be_closed
      end
    end
  end
end
