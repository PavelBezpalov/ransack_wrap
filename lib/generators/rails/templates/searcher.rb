<%- module_namespacing do -%>
class <%= class_name %>Searcher < RansackWrap::Search
  class Scopes < RansackWrap::Scopes
    # Custom searchable keys
    # attribute :only_sale, type: ActiveAttr::Typecasting::Boolean
    # attribute :opt_in
    # attribute :cat_in
    
    # Custom searchable method for key :only_sale with scope
    # def scope_only_sale(value)
    #   @object.joins_discount
    # end
    
    # Custom searchable method for key :opt_in with values for complex scope
    # def scope_opt_in(values)
    #   @object.with_options_intersect(values.values)
    # end
    
    # Custom searchable method for key :cat_in with simple conditions
    # def scope_cat_in(value)
    #  @object.where(category_id: value)
    # end
  end
  
  # Delegation to searchers (uncomment and fill with your keys from class above)
  # delegate :only_sale, :opt_in, :cat_in, to: :base
end
<% end -%>