require 'has_browser'

ActiveRecord::Base.send(:include, HasBrowser)
[ActiveRecord::Associations::HasManyAssociation, ActiveRecord::Associations::HasManyThroughAssociation].each do |c|
  c.send(:include, HasBrowser::AssociationProxyMethods)
end
