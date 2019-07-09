require 'ostruct'

class AnonymousFeedbackApiResponse < OpenStruct
  def beyond_last_page?
    pages.positive? && current_page > pages
  end
end
