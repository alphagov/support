crumb :root do
  link "Home", root_path
end

crumb :request do |request|
  link request.class.label
  parent :root
end

crumb :feedex do
  link "Feedback", anonymous_feedback_explore_path
  parent :root
end

crumb :anonymous_feedback_by_path do |path|
  link "Feedback for “#{path}”"
  parent :feedex
end
