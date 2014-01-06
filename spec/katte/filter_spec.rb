require 'spec_helper'
require 'katte/filter'

class Katte
  describe Filter do
    describe ".call" do
      it "validate date" do
        filter = Filter.new(datetime: DateTime.parse('2013-01-01'))
        expect(filter.call(period: 'day')).to be_true
        expect(filter.call(period: 'week')).to be_false
        expect(filter.call(period: 'month')).to be_true

        filter = Filter.new(datetime: DateTime.parse('2013-01-07'))
        expect(filter.call(period: 'day')).to be_true
        expect(filter.call(period: 'week')).to be_true
        expect(filter.call(period: 'month')).to be_false
      end
    end
  end
end
