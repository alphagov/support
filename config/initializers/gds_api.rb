require 'gds_api/base'

GdsApi::Base.default_options = { timeout: 30 }

if %w(development test).include? Rails.env
  GdsApi::Base.default_options[:disable_cache] = true
end
