require "rails_helper"

module Support
  module Requests
    describe TechnicalFaultReport do
      it { should validate_presence_of(:requester) }
      it { should validate_presence_of(:fault_context) }
      it { should validate_presence_of(:fault_specifics) }
      it { should validate_presence_of(:actions_leading_to_problem) }
      it { should validate_presence_of(:what_happened) }
      it { should validate_presence_of(:what_should_have_happened) }

      it "is Inside Government-related if the fault is caused by an Inside Government technical component" do
        expect(TechnicalFaultReport.new(fault_context: double(inside_government_related?: true))
          .inside_government_related?).to be_truthy
        expect(TechnicalFaultReport.new(fault_context: double(inside_government_related?: false))
          .inside_government_related?).to be_falsey
      end

      it "assigns fault_context to a 'do_not_know' UserFacingComponent when 'do_not_know' is passed into the 'fault_context_attributes' 'name' attribute" do
        report = described_class.new(fault_context_attributes: { name: "do_not_know" })
        expect(report.fault_context.id).to eq "do_not_know"
        expect(report.fault_context.name).to eq "Do not know"
      end

      describe "#fault_context_options" do
        it "adds a 'do_not_know' option to fault_context_options" do
          do_not_know_option = described_class.new.fault_context_options.find { |option| option.id == "do_not_know" }
          expect(do_not_know_option.name).to eq "Do not know"
        end
      end
    end
  end
end
