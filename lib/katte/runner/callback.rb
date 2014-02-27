module Katte::Runner::Callback
  module ClassMethods
    def before(task_name, &proc)
      before_callbacks[task_name] ||= []
      before_callbacks[task_name] << proc
    end
    def after(task_name, &proc)
      after_callbacks[task_name] ||= []
      after_callbacks[task_name] << proc
    end

    def after_callbacks
      @after_callbacks ||= {}
    end
    def before_callbacks
      @before_callbacks ||= {}
    end
  end

  def self.included(klass)
    klass.extend ClassMethods
  end
  
  def call_before_callbacks(task_name, *params)
    return unless self.class.before_callbacks[task_name]
    self.class.before_callbacks[task_name].each do |proc|
      proc.call(*params)
    end
  end
  def call_after_callbacks(task_name, *params)
    return unless self.class.after_callbacks[task_name]
    self.class.after_callbacks[task_name].each do |proc|
      proc.call(*params)
    end
  end
end
