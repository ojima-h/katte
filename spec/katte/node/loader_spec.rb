require 'spec_helper'

require 'katte/node/loader'

class Katte::Node
  describe Loader do
    it "load all node under recipes root" do
      nodes = Loader.load(Katte.config.recipes_root)
      expect(nodes.length).to eq 5
      expect(nodes.map(&:name)).to include("test/sample")
      expect(nodes.map(&:name)).to include("test/sample/sub")
    end
  end
end
