module Support
  module GDS
    module WithUserNeeds
      attr_accessor :user_needs

      def self.included(base)
        base.validates_presence_of :user_needs
        base.validate :allowed_user_needs, :at_least_one_user_need
      end

      def formatted_user_needs
        filtered_user_needs.map {|user_need| Hash[user_need_options].key(user_need) }.sort.join(", ")
      end

      def inside_government_related?
        not (%w{inside_government_editor inside_government_writer} & filtered_user_needs).empty?
      end

      def user_need_options
        [
          ["Departments and policy writer permissions", "inside_government_writer"],
          ["Departments and policy editor permissions", "inside_government_editor"],
          ["to request new content and content changes", "content_change"],
          ["to request creation, deletion and changes to user permissions", "user_manager"],
          ["to request new campaigns", "campaign_requester"],
          ["Other/Not sure", "other"]
        ]
      end

      protected
      def filtered_user_needs
        (user_needs || []).reject(&:empty?)
      end

      def at_least_one_user_need
        if filtered_user_needs.empty?
          errors.add(:user_needs, "please choose at least one option")
        end
      end

      def allowed_user_needs
        permitted_user_needs = user_need_options.map(&:last)
        disallowed_needs = filtered_user_needs - permitted_user_needs
        unless disallowed_needs.empty?
          errors.add(:user_needs, disallowed_needs.join(", ") + " not valid user needs")
        end
      end
    end
  end
end
