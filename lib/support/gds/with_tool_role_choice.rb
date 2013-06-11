module Support
  module GDS
    module WithToolRoleChoice
      attr_accessor :tool_role

      def self.included(base)
        base.validates_presence_of :tool_role
        base.validates :tool_role, :inclusion => { 
          :in => %w(inside_government_writer inside_government_editor govt_form other),
          :message => "%{value} is not valid option"
        }
      end

      def formatted_tool_role
        Hash[tool_role_options].key(tool_role)
      end

      def inside_government_related?
        %w{inside_government_editor inside_government_writer}.include?(tool_role)
      end

      def tool_role_options
        [
          ["Inside Government editor", "inside_government_editor"],
          ["Inside Government writer", "inside_government_writer"],
          ["Departmental Contact Form", "govt_form"],
          ["Other/Not sure", "other"]
        ]
      end
    end
  end
end
