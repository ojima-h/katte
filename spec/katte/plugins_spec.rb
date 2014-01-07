require 'spec_helper'
require 'tempfile'

class Katte
  describe Plugins do
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
end
