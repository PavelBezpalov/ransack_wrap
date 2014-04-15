module RansackWrap
  class Search
    include Ransack::Naming
    
    class_attribute :ransack_aliases, instance_writer: false
    self.ransack_aliases = {}.with_indifferent_access
    
    attr_reader :base
    
    def initialize(object, params = {})
      @base = scope_class.new(object)
      
      params = {} unless params.is_a? Hash
      ransack_params = params.slice! *scope_keys+ransack_aliases.keys.map(&:to_sym)
      
      params.slice!(*scope_keys).each do |key, val|
        ransack_params[ransack_aliases[key].to_sym] = val
      end
      
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
      elsif ransack_alias_method?(name)
        ransack.send ransack_aliases[name], *args
      else
        super
      end
    end
  
    def respond_to?(method, include_private = false)
      super or begin
        name = method.to_s
        writer = name.sub!(/\=$/, '')
        base.attribute_method?(name) || ransack.respond_to?(name) || ransack_alias_method?(name) || false
      end
    end
    
    def self.alias_to_ransack(new_name, old_name, writer: true)
      new_hash = {}
      new_hash[new_name.to_s] = old_name.to_s
      new_hash["#{new_name}=".to_s] = "#{old_name}=" if writer
      ransack_aliases.merge! new_hash
    end
    
    private
    def ransack_alias_method?(name)
      ransack_aliases.key?(name) && ransack.respond_to?(ransack_aliases[name])
    end
    
    def scope_keys
      @scope_keys ||= base.attributes.keys.map(&:to_sym)
    end
    
    def scope_class
      raise NameError unless self.class.const_defined?(:Scopes)
      self.class.const_get(:Scopes)
    end
  end
end