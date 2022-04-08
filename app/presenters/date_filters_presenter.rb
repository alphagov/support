class DateFiltersPresenter
  attr_reader :from, :to

  def initialize(requested_from:, requested_to:, actual_from:, actual_to:)
    @requested_from = requested_from
    @requested_to = requested_to
    @from = parse_date(actual_from) if actual_from
    @to = parse_date(actual_to) if actual_to
  end

  def filtered?
    from.present? || to.present?
  end

  def attempted_to_filter?
    requested_from.present? || requested_to.present?
  end

  def invalid_filter?
    attempted_to_filter? && !filtered?
  end

private

  attr_reader :requested_from, :requested_to

  def parse_date(date)
    Date.parse(date).to_fs(:govuk_date_short)
  end
end
