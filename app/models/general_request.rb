class GeneralRequest < ActiveRecord::Base
  belongs_to :requester

  accepts_nested_attributes_for :requester

  validates_presence_of :requester
  validates_associated :requester
end