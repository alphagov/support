module Support
  module Requests
    module Anonymous
      module AnonymousContactValidations
        def self.included(base)
          base.validates :referrer, url: true, length: { maximum: 2048 }, allow_nil: true
          base.validates :url,      url: true, length: { maximum: 2048 }, allow_nil: true
          base.validates :path,     url: true, length: { maximum: 2048 }, allow_nil: true
          base.validates :details, length: { maximum: 2 ** 16 }
          base.validates_inclusion_of :javascript_enabled, in: [ true, false ]
          base.validates_inclusion_of :is_actionable, in: [ true, false ]
          base.validates_presence_of :reason_why_not_actionable, unless: "is_actionable"
        end
      end
    end
  end
end
