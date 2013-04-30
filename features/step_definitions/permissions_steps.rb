require 'active_support/inflector'

def request_class_for(request_name)
  (request_name.split + ["Request"]).map(&:capitalize).join.constantize
end

def perms_for(role)
  case role
  when "Anyone" then []
  when "Content requesters" then ["content_requesters"]
  when "Campaign requesters" then ["campaign_requesters"]
  when "Single points of contact" then ["single_points_of_contact"]
  when "User managers" then ["user_managers"]
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
      actually_has_permission = user_having(role).can? :manage, request_class_for(request_name)
      error_msg = "expected #{role} to #{has_permission == "N" ? 'not ' : ''}have access to #{request_name}"
      assert (has_permission == "Y") == (actually_has_permission), error_msg
    end
  end
end