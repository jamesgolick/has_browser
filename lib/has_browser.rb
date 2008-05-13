module HasBrowser
  def self.included(receiver)
    receiver.send :extend, ClassMethods
  end
  
  module ClassMethods
    def has_browser(*args)
      
    end
  end
end
