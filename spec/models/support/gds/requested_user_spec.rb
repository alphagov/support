require "rails_helper"

module Support
  module GDS
    describe RequestedUser do
      it { should validate_presence_of(:name) }
      it { should validate_presence_of(:email) }

      it { should allow_value("director").for(:job) }
      it { should allow_value("07911111").for(:phone) }
      it { should allow_value("ab@c.com").for(:email) }
      it { should allow_value("writing").for(:training) }
      it { should allow_value("using_publisher").for(:training) }
      it { should_not allow_value("derp").for(:training) }
      it { should_not allow_value("ab").for(:email) }

      describe "training validation" do
        context "when no options were provided" do
          subject { described_class.new }

          it "requires 'other' to be specified" do
            subject.validate

            expect(subject).to have(1).errors_on(:other_training)
          end
        end

        context "when one or more options were provided" do
          subject { described_class.new(training: %w(using_publisher)) }

          it "does not require 'other' to be specified" do
            subject.validate

            expect(subject).to have(0).errors_on(:other_training)
          end
        end
      end
    end
  end
end
