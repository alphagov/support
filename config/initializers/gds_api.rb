require 'gds_api/base'

if %w(development test).include? Rails.env
  GdsApi::Base.default_options = { disable_cache: true }
end
