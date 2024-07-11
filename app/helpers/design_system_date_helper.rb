module DesignSystemDateHelper
  def formatted_date(day, month, year)
    return "" unless year.present? && month.present? && day.present?

    date_args = [year, month, day].map(&:to_i)
    begin
      date = Date.new(*date_args)
    rescue Date::Error
      errors.add :base, message: "The provided date is invalid."
      return
    end
    "#{date.strftime('%d')}-#{date.strftime('%m')}-#{date.strftime('%Y')}"
  end
end
