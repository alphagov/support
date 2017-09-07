require 'rails_helper'

describe(ReferrerHelper) do
  include ReferrerHelper

  context('friendly_referrer') do
    it('shows the hostname for external sites') do
      expect(friendly_referrer('http://www.google.co.uk/search?q=public+holidays+in+uk&hl=en-GB&gbv=2&oq=&gs_l=')).to eq('google.co.uk')
      expect(friendly_referrer('http://www.bing.com/search?q=4th+May+2015+Bank+Holiday&FORM=QSRE1')).to eq('bing.com')
      expect(friendly_referrer('https://www.google.ie/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&ved=0CCEQFjAA&url=https%3A%2F%2Fwww.gov.uk%2Fbank-holidays')).to eq('google.ie')
    end

    it('can handle invalid URIs') do
      expect(friendly_referrer('httttp:/123')).to eq('httttp:/123')
    end

    it('shows the path for internal referrers') do
      expect(friendly_referrer('https://www.gov.uk/search?q=Bank+holidays')).to eq('/search')
      expect(friendly_referrer('https://www.gov.uk/bank-holidays')).to eq('/bank-holidays')
      expect(friendly_referrer('https://www.gov.uk/')).to eq('/')
    end

    it('can handle incorrectly encoded query strings') do
      expect(friendly_referrer('https://www.gov.uk/search?q=Taxed%20to%2')).to eq('/search')
    end
  end

  context('extract_search_term') do
    it('can extract a search term from a referrer') do
      expect(extract_search_term('https://www.gov.uk/search?q=Bank+holidays')).to eq('Bank holidays')
      expect(extract_search_term('http://www.google.co.uk/search?q=public+holidays+in+uk&hl=en-GB&gbv=2&oq=&gs_l=')).to eq('public holidays in uk')
      expect(extract_search_term('http://www.bing.com/search?q=4th+May+2015+Bank+Holiday&FORM=QSRE1')).to eq('4th May 2015 Bank Holiday')
    end

    it('can handle incorrectly encoded query strings') do
      expect(extract_search_term('https://www.gov.uk/search?q=Taxed%20to%2')).to eq(nil)
    end
  end
end
