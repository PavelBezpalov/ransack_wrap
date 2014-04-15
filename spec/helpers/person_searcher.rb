# :nodoc: all

class PersonSearcher < RansackWrap::Search
  class Scopes < RansackWrap::Scopes
    attribute :only_with_large_salary, type: ActiveAttr::Typecasting::Boolean
    
    def scope_only_with_large_salary(value)
      scoped.with_large_salary
    end
  end
  
  alias_to_ransack :in_family_with, :children_name_or_parent_name_cont
end