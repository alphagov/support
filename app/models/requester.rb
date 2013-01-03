require 'tableless_model'
require 'name_guesser'

class Requester < TablelessModel
  attr_accessor :email
  attr_writer :name

  validates_presence_of :email
  validates :email, :format => {:with => /@/}

  validate :collaborator_emails_are_all_valid

  def name
    @name || NameGuesser.new.guess_from_email(self.email)
  end

  def collaborator_emails
    @collaborator_emails || []
  end

  def collaborator_emails=(emails_as_string)
    @collaborator_emails = emails_as_string.split(",").collect(&:strip)
  end

  def collaborator_emails_are_all_valid
    unless collaborator_emails.blank?
      collaborator_emails.each do |collaborator_email|
        unless collaborator_email =~ /@/
          errors.add(:collaborator_emails, "#{collaborator_email} is not a valid email")
        end
      end
    end
  end
end