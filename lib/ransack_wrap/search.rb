module RansackWrap
  class Search
    include Ransack::Naming
    
    attr_reader :base
    
    def initialize(object, params = {})
      @base = scope_class.new(object)
      
      params ||= {}
      ransack_params = params.slice! *base.attributes.keys.map(&:to_sym)
      ransack_params ||= {}
      
      build params.with_indifferent_access 
      ransack.build ransack_params.with_indifferent_access
    end
    
    def ransack
      @ransack ||= build_for_ransack.ransack
    end
  
    def result
      ransack.result
    end
    
    def build(params = {})
      params.each {|key, value| base.send "#{key}=", value }
    end
    
    def build_for_ransack
      base.attributes
        .collect             {|name, args|  base.try_scope name, args }.compact
        .inject(base.scoped) {|scope, subq| scope.merge subq }
    end
  
    def method_missing(method, *args)
      name = method.to_s
      writer = name.sub! /\=$/, ''
      
      if base.attribute_method? name
        base.send method, *args
      elsif ransack.respond_to? name
        ransack.send method, *args
      else
        super
      end
    end
  
    def respond_to?(method, include_private = false)
      super or begin
        name = method.to_s
        writer = name.sub!(/\=$/, '')
        base.attribute_method?(name) || ransack.respond_to?(name) || false
      end
    end
    
    private
    def scope_class
      raise NameError unless self.class.const_defined?(:Scopes)
      self.class.const_get(:Scopes)
    end
  end
end