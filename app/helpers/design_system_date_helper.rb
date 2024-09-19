module DesignSystemDateHelper
  def formatted_date(day, month, year)
    return "" unless year.present? && month.present? && day.present?

    return errors.add(:base, message: "The provided date is invalid.") unless year.match?(/^\d+$/)

    begin
      date = Date.strptime("#{year}-#{month}-#{day}", "%Y-%m-%d")
      date.strftime("%d-%m-%Y")
    rescue ArgumentError
      errors.add :base, message: "The provided date is invalid."
      nil
    end
  end
end
