module ErrorsHelper
  def errors_for(errors, attribute)
    return nil if errors.blank?

    errors.filter_map { |error|
      if error.attribute == attribute
        { text: error.full_message }
      end
    }
    .presence
  end

  def error_for(errors, attribute)
    return nil if errors.blank?

    error = errors.find {|err| err.attribute == attribute}
    return nil if error.blank?
    error.full_message
  end

  def errors_for_summary(errors)
    return nil if errors.blank?

    errors.map do |error|
      {
        text: error.full_message,
        href: "##{error.attribute}",
      }
    end
  end
end
