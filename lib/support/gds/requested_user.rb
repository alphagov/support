require 'active_model/model'

module Support
  module GDS
    class RequestedUser
      include ActiveModel::Model
      attr_accessor :name, :email, :job, :phone, :training, :other_training

      validates_presence_of :name, :email
      validates :email, :format => {:with => /@/}

      def formatted_training
        training.reject(&:empty?).map do |k|
          self.class.training_options.key(k.to_sym)
        end.to_sentence
      end

      def self.training_options
        {
          "Writing for GOV.UK" => :writing,
          "Using Whitehall Publisher" => :using_publisher,
        }
      end
    end
  end
end
