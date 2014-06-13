# Ransack Wrap

This gem provides the object-like way to create search forms with handly named params, which can be used in custom query methods (scopes) or as aliases for the very long Ransack params (e.g., `q[bill_info_cont]` instead of  `q[user_bill_address_fullname_or_user_bill_address_phone_or_user_bill_address_address_cont]` ;) ). You'll still be able to use the usual Ransack params in these forms.

## Installation

Add this line to your application's Gemfile:

    gem 'ransack_wrap'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ransack_wrap

## Usage

Use "generator" (actually, it is temporary just an example) to create your search form class, e.g. for the Product model:

    rails g searcher product


#### Searcher class

It will create `ProductSearcher` class in `app/searchers/product_searcher.rb` with some instructions in the commented lines. Follow these instructions and write your code. There are some moments:

* Add `attribute` line for each custom searchable keys. You can use attribute defaults and typecasting from the  [active_attr](https://github.com/cgriego/active_attr) gem. 
* Create method with query logic for each keys, it should be named with the `scope` prefix, i.e. `scope_#{attribute_name}`.
* `@object` is an `ActiveRecord::Relation` object for model, so you can use usual querying and scoping methods. 
* Don't forget to delegate keys.

There is an example: 

````ruby
class ProductSearcher < RansackWrap::Search
  class Scopes < RansackWrap::Scopes
    # Custom searchable keys
    attribute :only_sale, type: ActiveAttr::Typecasting::Boolean
    attribute :opt_in
    attribute :cat_in
    
    # Custom searchable method for key :only_sale with scope
    def scope_only_sale(value)
      @object.joins_discount
    end
    
    # Custom searchable method for key :opt_in with values for complex scope
    def scope_opt_in(values)
      @object.with_options_intersect(values.values)
    end
    
    # Custom searchable method for key :cat_in with simple conditions
    def scope_cat_in(value)
      @object.where(category_id: value)
    end
  end
  
  # Delegation to searchers (uncomment and fill with your keys from class above)
  delegate :only_sale, :opt_in, :cat_in, to: :base
  
  # Alias to Ransack params
  alias_to_ransack :in_titles, :title_or_subtitle_or_category_title_cont
end
````

#### In your controller
Like with the usual Ransack.
     
````ruby
@q = Product.wrap_searcher(params[:q])
@products = @q.result
````

If you want custom searcher class, e.g., `SharedSearcher`, than use `Product.wrap_searcher_as(:shared, params[:q])`) instead `Product.wrap_searcher(params[:q])`.

#### In your view

Use the `search_form_for` like with usual Ransack. It was partly overriden, see [RansackWrap::Helpers::FormHelper](lib/ransack_wrap/helpers/form_helper.rb).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
