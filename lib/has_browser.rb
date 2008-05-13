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
      
      has_browser_allowed_finders[:without_args] = args.extract_options![:without_args] || []
      has_browser_allowed_finders[:with_args]    = args
    end
  end
  
  module BrowserMethods
    def browse(*args)
      params = args.extract_options!
      
      invalid_finders = params.keys.reject { |k| has_browser_allowed_finders.values.inject(&:+).include?(k) }
      raise InvalidFinder.new(invalid_finders.join(', ').to_s) unless invalid_finders.empty?
      
      params.inject(args.first || self) do |proxy, finder|
        has_browser_allowed_finders[:with_args].include?(finder.first.to_sym) ? proxy.send(finder.first, finder.last) : proxy.send(finder.first)
      end
    end
  end
  
  module AssociationProxyMethods
    def self.included(receiver)
      receiver.class_eval do
        alias_method_chain :method_missing, :has_browser
      end
    end
    
    def method_missing_with_has_browser(method, *args, &block)
      method == :browse && proxy_reflection.klass.respond_to?(:has_browser_allowed_finders) ? proxy_reflection.klass.browse(self, args.extract_options!) : method_missing_without_has_browser(method, *args, &block)
    end
  end
end
