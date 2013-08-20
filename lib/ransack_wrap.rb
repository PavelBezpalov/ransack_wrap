require "ransack_wrap/version"
require "ransack_wrap/search"
require "ransack_wrap/scopes"
require 'ransack_wrap/active_record'
require 'ransack_wrap/helpers'
require 'ransack_wrap/railtie' if defined?(Rails)

module RansackWrap
  # Your code goes here...
end

ActionController::Base.helper Ransack::Helpers::FormHelper