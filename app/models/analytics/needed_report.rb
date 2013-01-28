require 'shared/tableless_model'

class NeededReport < TablelessModel
  attr_accessor :reporting_period_start, 
                :reporting_period_end,
                :pages_or_sections,
                :non_standard_requirements,
                :frequency

  validates_presence_of :reporting_period_start,
                        :reporting_period_end,
                        :pages_or_sections,
                        :frequency

  validates :frequency, inclusion: { 
      in: %w(one-off weekly monthly),
      message: "%{value} is not valid option"
    }

  def frequency_options
    [
      ["One-off", "one-off"],
      ["Weekly", "weekly"],
      ["Monthly", "monthly"],
    ]
  end

  def formatted_frequency
    Hash[frequency_options].key(frequency)
  end

  def reporting_period
    "From #{reporting_period_start} to #{reporting_period_end}"
  end
end