require "rubygems"
require "mocha"
require "activesupport"
require "test/unit"
require File.dirname(__FILE__)+"/../lib/has_browser"

class PhotoMock
  include HasBrowser
  
  has_browser :title, :description, :without_args => [:order_by_date, :order_by_relevance]
end
