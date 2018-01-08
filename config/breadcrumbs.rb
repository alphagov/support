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

crumb :organisation do |organisation_name|
  link organisation_name, anonymous_feedback_organisation_path
  parent :feedex
end

crumb :document_type do |document_type|
  link document_type, anonymous_feedback_document_type_path
  parent :feedex
end

crumb :anonymous_feedback_by_filter do |filter|
  link "Feedback for “#{filter}”"
  parent :feedex
end

crumb :emergency_contact_details do
  link "Emergency contact details", emergency_contact_details_path
  parent :root
end
