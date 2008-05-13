module HasBrowser
  class InvalidFinder < ArgumentError; end
  
  def self.included(receiver)
    receiver.send :extend, ClassMethods
  end
  
  module ClassMethods
    def has_browser(*args)
      extend BrowserMethods
      class_inheritable_accessor  :has_browser_allowed_finders
      self.has_browser_allowed_finders = {}
      
      has_browser_allowed_finders[:without_args] = (args.extract_options! || {})[:without_args] || []
      has_browser_allowed_finders[:with_args]    = args
    end
  end
  
  module BrowserMethods
    def browse(params={})
      invalid_finders = params.keys.reject { |k| has_browser_allowed_finders.values.inject(&:+).include?(k) }
      raise InvalidFinder.new(invalid_finders.join(', ').to_s) unless invalid_finders.empty?
    end
  end
end
