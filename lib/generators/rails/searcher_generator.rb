module Rails
  module Generators
    class SearcherGenerator < NamedBase
      source_root File.expand_path("../templates", __FILE__)
      check_class_collision suffix: "Searcher"
      
      def create_searcher_file
        template 'searcher.rb', File.join('app/searchers', class_path, "#{file_name}_searcher.rb")
      end
      
      # hook_for :test_framework
      unless methods.include?(:module_namespacing)
        def module_namespacing
          yield if block_given?
        end
      end
    end
  end
end