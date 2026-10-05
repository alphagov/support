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
