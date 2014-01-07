require 'spec_helper'

class Katte::Node
  describe Loader do
    it "load all node under recipes root" do
      nodes = Loader.load(Katte.config.recipes_root)

      recipes_num = Dir.glob(File.join(Katte.config.recipes_root, '**', '*')).select{|f| FileTest.file? f}.length

      expect(nodes.length).to eq recipes_num
      expect(nodes.map(&:name)).to include("test/sample")
      expect(nodes.map(&:name)).to include("test/sample/sub")
    end
  end
end
