require 'zendesk_client'
require 'active_support'

class ZendeskUsers
  def initialize(client = nil)
    @client = client || ZendeskClient.get_client(logger)
  end

  def create_or_update_user(requested_user)
    existing_users = find_by_email(requested_user.email)
    if existing_users.empty?
      create(requested_user)
    else
      existing_user_in_zendesk = existing_users.first
      update(existing_user_in_zendesk, requested_user)
    end
  end

  protected
  def find_by_email(email)
    @client.users.search(query: email).to_a
  end

  def create(requested_user)
    @client.users.create(email:   requested_user.email, 
                         name:    requested_user.name,
                         details: "Job title: #{requested_user.job}",
                         phone:   requested_user.phone)
  end

  def update(existing_user_in_zendesk, requested_user)
    existing_user_in_zendesk.update(details: "Job title: #{requested_user.job}")
    existing_user_in_zendesk.update(phone: requested_user.phone) unless requested_user.phone.blank?
    existing_user_in_zendesk.save
    existing_user_in_zendesk
  end
end