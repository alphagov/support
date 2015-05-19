require 'rails_helper'

describe(DateFilterHelper) do
  include DateFilterHelper

  context('date_filtered?') do
    it('knows when feedback has been filtered') do
      expect(date_filtered?).to be(false)

      @from_date = '10 May 2015'
      expect(date_filtered?).to be(true)
    end
  end

  context('total_responses_header') do
    it('gives details about responses and date filter') do
      expect(total_responses_header(1000, '10 May', '11 May')).to eq('1,000 responses between 10 May and 11 May')
      expect(total_responses_header(1000, '10 May',  nil)).to eq('1,000 responses since 10 May')
      expect(total_responses_header(1000, nil, '11 May')).to eq('1,000 responses before 11 May')
      expect(total_responses_header(1000, nil, nil)).to eq('All 1,000 responses')
      expect(total_responses_header(1, nil, nil)).to eq('1 response')
    end
  end

end
