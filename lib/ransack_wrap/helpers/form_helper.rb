# :stopdoc:

module RansackWrap
  module Helpers
    module FormHelper
      # :startdoc:
      
      ##
      # Extends original +search_form_for+ method from Ransack gem 
      # to also support RansackWrap::Search instances.
      def search_form_for(record, options = {}, &proc)
        if record.is_a?(Ransack::Search) || record.is_a?(RansackWrap::Search)
          search = record
          options[:url] ||= polymorphic_path(search.klass)
        elsif record.is_a?(Array) && (search = record.detect {|o| o.is_a?(Ransack::Search) || o.is_a?(RansackWrap::Search)})
          options[:url] ||= polymorphic_path(record.map {|o| 
            o.is_a?(Ransack::Search) || record.is_a?(RansackWrap::Search) ? o.klass : o
          })
        else
          raise ArgumentError, "No Ransack::Search or RansackWrap::Search object was provided to search_form_for!"
        end
        options[:html] ||= {}
        html_options = {
          :class  => options[:class].present? ? "#{options[:class]}" : "#{search.klass.to_s.underscore}_search",
          :id => options[:id].present? ? "#{options[:id]}" : "#{search.klass.to_s.underscore}_search",
          :method => :get
        }
        options[:as] ||= 'q'
        options[:html].reverse_merge!(html_options)
        options[:builder] ||= Ransack::Helpers::FormBuilder
        
        form_for(record, options, &proc)
      end
      
    end
  end
end