module RansackWrap
  class Scopes
    include ActiveAttr::TypecastedAttributes
    attr_reader :object
    
    def initialize(object)
      @object = object
    end
    
    def scoped
      object.scoped
    end
    
    def attribute_method?(attr_name)
      respond_to_without_attributes?(:attributes) && attr_name.in?(attributes)
    end
    
    def try_scope(name, args)
      return unless args.present?
      self.try "scope_#{name}", args
    end
  end
end