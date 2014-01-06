class Katte
  class Environment
    attr_accessor :datetime
    def initialize(options = {})
      @datetime = options[:datetime] ? DateTime.parse(options[:datetime]) : DateTime.now
    end

    def to_hash
      @hash ||= {
        'date' => @datetime.strftime('%Y-%m-%d'),
      }
    end
  end
end
