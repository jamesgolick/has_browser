require File.dirname(__FILE__)+'/test_helper'

class HasBrowserTest < Test::Unit::TestCase
  def test_should_call_appropriate_finders_when_somebody_browses_by_parameters
    PhotoMock.expects(:title).with('something').returns(PhotoMock)
    PhotoMock.expects(:description).with('lorem ipsum dolor').returns(PhotoMock)
    PhotoMock.expects(:order_by_date).returns(PhotoMock)
    
    PhotoMock.browse(:title => 'something', :description => 'lorem ipsum dolor', :order_by_date => 'true')
  end
  
  def test_browsing_with_an_alternate_target
    proxy_mock = mock
    proxy_mock.expects(:title).with('something').returns(proxy_mock)
    proxy_mock.expects(:description).with('lorem ipsum dolor').returns(proxy_mock)
    proxy_mock.expects(:order_by_date).returns(proxy_mock)
    
    PhotoMock.browse(proxy_mock, :title => 'something', :description => 'lorem ipsum dolor', :order_by_date => 'true')
  end
  
  def test_association_proxy_finder_should_proxy_to_the_reflected_class_browse_method
    proxy_mock = AssocProxyMock.new
    proxy_mock.stubs(:proxy_reflection).returns(stub(:klass => PhotoMock))
    
    PhotoMock.expects(:browse).with(proxy_mock, :title => 'something', :description => 'lorem ipsum dolor', :order_by_date => 'true')
    
    proxy_mock.browse(:title => 'something', :description => 'lorem ipsum dolor', :order_by_date => 'true')
  end
  
  def test_association_proxy_should_raise_if_browse_is_called_and_target_doesnt_have_a_browser
    proxy_mock = AssocProxyMock.new
    proxy_mock.stubs(:proxy_reflection).returns(stub(:klass => String))
    
    assert_raise(NoMethodError) do
      proxy_mock.browse({})
    end
  end
  
  def test_should_not_raise_when_keys_are_strings
    PhotoMock.stubs(:title)
    assert_nothing_raised do
      PhotoMock.browse('title' => 'asdf')
    end
  end
  
  def test_should_raise_invalid_finder_exception_if_somebody_tries_to_browse_by_a_finder_not_specified_in_the_browse_call
    assert_raise(HasBrowser::InvalidFinder) do
      PhotoMock.browse(:invalid => 'danger!')
    end
  end
end
