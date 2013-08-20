require 'active_record'

module RansackWrap
  module Adapters
    module ActiveRecord
      module Base
        def wrap_searcher_as(name, params = {})
          send(:searcher_class_for, name).new(self, params)
        end
        
        def wrap_searcher(params = {})
          send :wrap_searcher_as, nil, params
        end
        
        private        
        def searcher_class_for(name)
          name = name.to_s.camelize unless name.nil?
          name ||= self.scoped.klass.name
          name.concat("Searcher").constantize
        end
      end
    end
  end
end

ActiveRecord::Base.extend RansackWrap::Adapters::ActiveRecord::Base