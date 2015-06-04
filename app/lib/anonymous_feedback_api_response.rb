require 'ostruct'

class AnonymousFeedbackApiResponse < OpenStruct
  def beyond_last_page?
    pages > 0 && current_page > pages
  end
end
