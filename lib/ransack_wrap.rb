require "ransack_wrap/version"

require "active_support/core_ext"
require "active_attr"
require "ransack"

require "ransack_wrap/search"
require "ransack_wrap/scopes"
require "ransack_wrap/adapters/active_record"
require "ransack_wrap/helpers"
require "ransack_wrap/railtie" if defined?(Rails)

module RansackWrap
  # Your code goes here...
end

# :stopdoc:
ActionController::Base.helper RansackWrap::Helpers::FormHelper