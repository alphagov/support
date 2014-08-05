crumb :root do
  link "Home", root_path
end

crumb :request do |request|
  link request.class.label
  parent :root
end
