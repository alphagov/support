json.array! @feedback do |item|
  json.extract! item, :what_wrong, :what_doing, :created_at, :url, :referrer,
                      :slug, :details, :service_satisfaction_rating
end
