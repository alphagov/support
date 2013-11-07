require 'active_support/inflector'
require 'support/requests'

def request_class_for(request_name)
  class_name_suffix = request_name =~ /report|contact|feedback/ ? [] : ["Request"]
  classname = (request_name.split + class_name_suffix).map(&:capitalize).join
  if ["ProblemReport", "LongFormContact", "ServiceFeedback"].include? classname
    "Support::Requests::Anonymous::#{classname}".constantize
  else
    "Support::Requests::#{classname}".constantize
  end
end

def perms_for(role)
  case role
  when "Anyone" then []
  when "Content requesters" then ["content_requesters"]
  when "Campaign requesters" then ["campaign_requesters"]
  when "Single points of contact" then ["single_points_of_contact"]
  when "User managers" then ["user_managers"]
  when "API users" then ["api_users"]
  else
    raise "unexpected role: #{role}"
  end
end

def user_having(role)
  User.new(permissions: perms_for(role))
end

Given /^The role\/request matrix:$/ do |table|
  table.hashes.each do |row|
    request_name = row["Role"]
    row.each do |role, has_permission|
      next if role == "Role"
      actually_has_permission = user_having(role).can? :create, request_class_for(request_name)
      error_msg = "expected #{role} to #{has_permission == "N" ? 'not ' : ''}have access to #{request_name}"
      assert (has_permission == "Y") == (actually_has_permission), error_msg
    end
  end
end
