require 'spec_helper'

class Katte
  describe Config do
    it "set params to Katte::Config" do
      config_bak = Katte::Config.config.recipes_root

      config = Class.new(Katte::Config) do |klass|
        klass.config.recipes_root = 'dummy'
      end

      expect(Katte::Config.config.recipes_root).to eq 'dummy'
      Katte::Config.config.recipes_root = config_bak
    end
  end
end
