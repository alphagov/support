RSpec.describe Support::Requests::Anonymous::Paths do
  let(:paths) { %w(/test-1 /test-2) }
  let(:id) { nil }

  subject { described_class.new(paths, id) }

  it "can be saved" do
    expect { subject.save }.to_not raise_error
  end

  it "can be saved and loaded" do
    subject.save
    expect(subject.paths).to eq(described_class.find(subject.id).paths)
  end

  context "with an existing ID" do
    let(:id) { "test-id" }

    it "cannot be found" do
      expect(described_class.find(id)).to be_nil
    end

    context "and saving it first" do
      before { subject.save }

      it "can be found" do
        expect(described_class.find(id)).to_not be_nil
      end
    end
  end
end
