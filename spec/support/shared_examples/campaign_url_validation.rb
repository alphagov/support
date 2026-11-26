RSpec.shared_examples "a campaign URL validation" do
  it { should allow_value("example.campaign.gov.uk").for(:proposed_url) }
  it { should allow_value("example.gov.uk").for(:proposed_url) }
  it { should allow_value("my-campaign.campaign.gov.uk").for(:proposed_url) }
  it { should allow_value("MyCampaign.campaign.gov.uk").for(:proposed_url) }
  it { should allow_value("example.campaign.gov.uk/").for(:proposed_url) }
  it { should_not allow_value("www.example.com").for(:proposed_url) }
  it { should_not allow_value("example.campaign.gov.u").for(:proposed_url) }
  it { should_not allow_value("example.campaign.gov-uk").for(:proposed_url) }
  it { should_not allow_value("junk example.campaign.gov.uk").for(:proposed_url) }
  it { should_not allow_value("example.campaign.gov.uk junk").for(:proposed_url) }

  it "strips surrounding whitespace from the proposed URL" do
    model = described_class.new(proposed_url: " example.campaign.gov.uk ")
    expect(model.proposed_url).to eq("example.campaign.gov.uk")
  end
end
