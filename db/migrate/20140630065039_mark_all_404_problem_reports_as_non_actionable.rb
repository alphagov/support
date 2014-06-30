class MarkAll404ProblemReportsAsNonActionable < ActiveRecord::Migration
  class AnonymousContact < ActiveRecord::Base; end

  def up
    AnonymousContact.
      where(what_wrong: "broken link (404)").
      update_all(is_actionable: false, reason_why_not_actionable: 'non-actionable broken link reports')
  end

  def down
    AnonymousContact.
      where(what_wrong: "broken link (404)").
      update_all(is_actionable: true, reason_why_not_actionable: nil)
  end
end
