require 'active_model/model'

module Support
  module GDS
    class RequestedUser
      include ActiveModel::Model
      attr_accessor :name, :email, :job, :phone, :training, :other_training

      TRAINING_OPTIONS = {
        "Writing for GOV.UK" => "writing",
        "Using Whitehall Publisher" => "using_publisher",
      }

      validates_presence_of :name, :email
      validates :email, :format => {:with => /@/}
      validates :other_training, presence: true, if: -> { training.empty? }
      validate :training_options

      def formatted_training
        training.map { |k| TRAINING_OPTIONS.key(k) }.to_sentence
      end

      def training
        Array(@training).reject(&:empty?)
      end

    private
      def training_options
        unless (training - TRAINING_OPTIONS.values).empty?
          errors.add(:training, "must be one of the provided options")
        end
      end
    end
  end
end
