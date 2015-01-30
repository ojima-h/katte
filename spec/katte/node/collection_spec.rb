require 'spec_helper'

module Katte::Node
  describe Collection do
    before :all do
      node_class = Class.new do
        include Katte::Node::Base

        def initialize(params)
          @name     = params[:name]
          @requires = params[:require]
        end
        def name; @name; end
      end
        
      @node_collection = Katte::Node::Collection.new
      @node_collection << node_class.new(name: "a")
      @node_collection << node_class.new(name: "b")
      @node_collection << node_class.new(name: "c", require: ["b", "e"])
      @node_collection << node_class.new(name: "d", require: ["b"])

      @node_collection.connect
    end

    describe '#connect' do
      it "ignores unregistered nodes" do
        expect(@node_collection.find("c").parents.map(&:name)).not_to include "e"
        expect(@node_collection.find("c").parents).not_to include "e"
      end
      it "connect parents and childs" do
        expect(@node_collection.find("b").children.map(&:name)).to eq %w(c d)
        expect(@node_collection.find("c").parents.map(&:name)).to eq %w(b)
      end
    end
  end
end
