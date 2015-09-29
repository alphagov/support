module Support
  module GDS
    module WithUserNeeds
      attr_accessor :user_needs

      def self.included(base)
        base.validates :user_needs, presence: true, inclusion: { in: %w{writer editor managing_editor other} }
        base.validate :allowed_user_needs
      end

      def formatted_user_needs
        Hash[whitehall_account_options].key(user_needs)
      end

      def inside_government_related?
        %w{editor writer managing_editor}.include?(user_needs)
      end

      def whitehall_account_options
        [
          ["writer - can create content", "writer"],
          ["editor - can create, review and publish content", "editor"],
          ["managing editor - can create, review and publish content, and additional rights", "managing_editor"],
          ["other", "other"]
        ]
      end

      protected

      def allowed_user_needs
        return user_needs if user_needs.class == String
        errors.add(:user_needs, " not valid user needs")
      end

    end
  end
end
