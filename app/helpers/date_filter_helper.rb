module DateFilterHelper

	def date_filtered?
		params[:from].present? || params[:to].present?
	end

end