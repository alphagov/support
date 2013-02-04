require 'shared/tableless_model'

class NeededReport < TablelessModel
  attr_accessor :reporting_period_start, 
                :reporting_period_end,
                :pages_or_sections,
                :non_standard_requirements,
                :frequency,
                :format

  validates_presence_of :reporting_period_start,
                        :reporting_period_end,
                        :pages_or_sections,
                        :frequency

  validates :frequency, inclusion: { 
      in: %w(one-off weekly monthly),
      message: "%{value} is not valid option"
    }

  validates :format, inclusion: { 
      in: %w(pdf csv),
      message: "%{value} is not valid option"
    }, allow_blank: true

  def frequency_options
    [
      ["One-off", "one-off"],
      ["Weekly", "weekly"],
      ["Monthly", "monthly"],
    ]
  end

  def format_options
    [
      ["CSV", "csv"],
      ["PDF", "pdf"],
    ]
  end

  def formatted_format
    Hash[format_options].key(format)
  end

  def formatted_frequency
    Hash[frequency_options].key(frequency)
  end

  def reporting_period
    "From #{reporting_period_start} to #{reporting_period_end}"
  end
end