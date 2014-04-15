require 'rails/railtie'

# :nodoc: all
module RansackWrap
  class Railtie < Rails::Railtie
    config.after_initialize do |app|
      app.config.paths.add 'app/searchers', eager_load: true
    end
  end
end

module ActiveModel
  class Railtie < Rails::Railtie
    generators do |app|
      app ||= Rails.application # Rails 3.0.x does not yield `app`
      
      Rails::Generators.configure! app.config.generators
    end
  end
end