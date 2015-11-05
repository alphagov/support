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
      validates :other_training, presence: true, if: -> { Array(training).empty? }
      validate :training_options

      def formatted_training
        training.reject(&:empty?).map { |k| TRAINING_OPTIONS.key(k) }.to_sentence
      end

    private
      def training_options
        unless (Array(training).reject(&:empty?) - TRAINING_OPTIONS.values).empty?
          errors.add(:training, "must be one of the provided options")
        end
      end
    end
  end
end
