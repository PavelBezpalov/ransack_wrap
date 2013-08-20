require 'rails/railtie'

module RansackWrap
  class Railtie < Rails::Railtie
    config.after_initialize do |app|
      app.config.paths.add 'app/searchers', eager_load: true
    end
  end
end