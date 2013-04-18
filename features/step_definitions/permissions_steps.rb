require 'active_support/inflector'

def request_class_for(request_name)
  (request_name.split + ["Request"]).map(&:capitalize).join.constantize
end

def role_class_for(role_name)
  role_name.split.map(&:capitalize).join.constantize
end

def example_user_for(role)
  case role.name
  when "Anyone" then stub("anyone", has_permission?: false)
  when "ContentRequesters" then StubUser.new(perms: ["content_requesters"])
  when "CampaignRequesters" then StubUser.new(perms: ["campaign_requesters"])
  else
    raise "unexpected role: #{role.name}"
  end
end

Given /^The role\/request matrix:$/ do |table|
  table.hashes.each do |row|
    role = role_class_for(row["Role"])
    row.each do |request_name, has_permission|
      next if request_name == "Role"
      request_class = request_class_for(request_name)
      example_user = example_user_for(role)

      error_msg = "expected #{row["Role"]} to #{has_permission == "N" ? 'not ' : ''}have access to #{request_name}"
      assert (has_permission == "Y") == (request_class.accessible_by_user?(example_user)), error_msg
    end
  end
end