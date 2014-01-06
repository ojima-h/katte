require 'date'

class Katte
  class Filter
    def initialize(options = {})
      @datetime = options[:datetime] || DateTime.now
    end

    def call(params)
      check_date(params)
    end

    private
    def check_date(params)
      case params[:period]
      when 'day'   then true
      when 'week'  then @datetime.wday == 1 # monday
      when 'month' then @datetime.day  == 1
      end
    end
  end
end
