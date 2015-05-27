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
      expect(total_responses_header(1000, Date.new(2015, 05, 10), Date.new(2015, 05, 11))).to eq('1,000 responses between 10 May 2015 and 11 May 2015')
      expect(total_responses_header(1000, Date.new(2015, 05, 10),  nil)).to eq('1,000 responses since 10 May 2015')
      expect(total_responses_header(1000, nil, Date.new(2015, 05, 11))).to eq('1,000 responses before 11 May 2015')
      expect(total_responses_header(1000, nil, nil)).to eq('All 1,000 responses')
      expect(total_responses_header(1, nil, nil)).to eq('1 response')
    end
  end
end
