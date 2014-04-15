require "active_record"

module RansackWrap
  # :stopdoc:
  module Adapters
    module ActiveRecord
      module Base
        # :startdoc:
        
        ##
        # Creates new searcher using RansackWrap::Search subclass for current model.
        #
        # In the example below it creates instance of +UserSearcher+ class (which must be defined in +app/searchers/user_searcher.rb)+
        # 
        #   User.wrap_searcher(params[:q])
        #   # => UserSearcher.new
        def wrap_searcher(params = {})
          send(:wrap_searcher_as, name, params)
        end
        
        ##
        # Creates new searcher using custom named searcher class.
        # 
        # In the example below it creates instance of +SharedSearcher+ class (which must be defined in +app/searchers/shared_searcher.rb)+
        # 
        #   User.wrap_searcher(:shared, params[:q]) 
        #   # => SharedSearcher.new
        # 
        # :call-seq:
        #   wrap_searcher_as(:name, params = {})
        #   wrap_searcher_as("name", params = {})
        def wrap_searcher_as(name, params = {})
          send(:searcher_class_for, name).new(self, params)
        end
        
        private
        def searcher_class_for(name)
          name.to_s.camelize.concat("Searcher").constantize
        end
      end
    end
  end
end

# :stopdoc:
ActiveRecord::Base.extend(RansackWrap::Adapters::ActiveRecord::Base)