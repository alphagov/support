require 'rails_helper'
require 'support/requests/anonymous/anonymous_contact'

class TestContact < Support::Requests::Anonymous::AnonymousContact
  attr_accessible :details, :what_wrong, :what_doing, :url
end

module Support
  module Requests
    module Anonymous
      describe AnonymousContact, :type => :model do
        DEFAULTS = { javascript_enabled: true, url: "https://www.gov.uk/tax-disc", path: "/tax-disc" }

        def new_contact(options = {})
          TestContact.new(DEFAULTS.merge(options))
        end

        def contact(options = {})
          new_contact(options).tap { |c| c.save! }
        end

        it "enforces the presence of a reason why feedback isn't actionable" do
          contact = new_contact(is_actionable: false, reason_why_not_actionable: "")
          expect(contact).to_not be_valid
          expect(contact).to have_at_least(1).error_on(:reason_why_not_actionable)
        end

        it "doesn't detect personal info when none is present in free text fields" do
          expect(contact(details: "abc", what_wrong: "abc", what_doing: "abc").personal_information_status).to eq("absent")
        end

        it "notices when an email is present in one of the free text fields" do
          expect(contact(details: "contact me at name@domain.com please").personal_information_status).to eq("suspected")
          expect(contact(what_doing: "contact me at name@domain.com please").personal_information_status).to eq("suspected")
          expect(contact(what_wrong: "contact me at name@domain.com please").personal_information_status).to eq("suspected")
        end

        it "notices when a national insurance number is present in one of the free text fields" do
          expect(contact(details: "my NI number is QQ 12 34 56 A thanks").personal_information_status).to eq("suspected")
          expect(contact(what_doing: "my NI number is QQ 12 34 56 A thanks").personal_information_status).to eq("suspected")
          expect(contact(what_wrong: "my NI number is QQ 12 34 56 A thanks").personal_information_status).to eq("suspected")
        end

        it "validates the personal_information_status field" do
          expect(new_contact(personal_information_status: nil)).to be_valid
          expect(new_contact(personal_information_status: "suspected")).to be_valid
          expect(new_contact(personal_information_status: "absent")).to be_valid

          expect(new_contact(personal_information_status: "abcde")).to_not be_valid
        end

        it "stores the relative path of the page from which the feedback was lodged" do
          contact = new_contact(url: "https://www.gov.uk/vat-rates")
          contact.save!
          expect(contact.path).to eq("/vat-rates")
        end

        context "URLs" do
          it { should allow_value("https://www.gov.uk/something").for(:url) }
          it { should allow_value(nil).for(:url) }
          it { should allow_value("http://" + ("a" * 2040)).for(:url) }
          it { should_not allow_value("http://" + ("a" * 2050)).for(:url) }
          it { should_not allow_value("http://bla.example.org:9292/méh/fào?bar").for(:url) }
        end

        context "path" do
          it { should allow_value("/something").for(:path) }
          it { should allow_value(nil).for(:path) }
          it { should allow_value("/" + ("a" * 2040)).for(:path) }
          it { should_not allow_value("/" + ("a" * 2050)).for(:path) }
          it { should_not allow_value("/méh/fào?bar").for(:path) }
        end

        context "referrer" do
          it { should allow_value("https://www.gov.uk/y").for(:referrer) }
          it { should allow_value(nil).for(:referrer) }
          it { should allow_value("http://" + ("a" * 2040)).for(:referrer) }
          it { should_not allow_value("http://" + ("a" * 2050)).for(:referrer) }
          it { should_not allow_value("http://bla.example.org:9292/méh/fào?bar").for(:referrer) }
        end

        it "marks duplicates as non-actionable" do
          contact = new_contact.tap(&:mark_as_duplicate)

          expect(contact.is_actionable).to be_falsy
          expect(contact.reason_why_not_actionable).to eq("duplicate")
        end

        context "#find_all_starting_with_path" do
          it "finds urls beginning with the given path" do
            a = contact(url: "https://www.gov.uk/some-calculator/y/abc")
            b = contact(url: "https://www.gov.uk/some-calculator/y/abc/x")
            c = contact(url: "https://www.gov.uk/tax-disc")

            result = TestContact.find_all_starting_with_path("/some-calculator")

            expect(result).to contain_exactly(a, b)
          end

          it "returns the results in reverse chronological order" do
            a, b, c = contact, contact, contact
            a.created_at = Time.now - 1.hour
            b.created_at = Time.now - 2.hour
            c.created_at = Time.now
            [a, b, c].map(&:save)

            expect(TestContact.find_all_starting_with_path(DEFAULTS[:path])).to eq([c, a, b])
          end

          it "only returns reports with no known personal information" do
            a = contact(personal_information_status: "absent")
            _ = contact(personal_information_status: "suspected")

            expect(TestContact.find_all_starting_with_path(DEFAULTS[:path])).to eq([a])
          end

          it "only returns actionable feedback" do
            a = contact(is_actionable: true)
            _ = contact(is_actionable: false, reason_why_not_actionable: "spam")

            expect(TestContact.find_all_starting_with_path(DEFAULTS[:path])).to eq([a])
          end

          after do
            TestContact.delete_all
          end
        end

        context "#deduplicate_contacts_created_between" do
          it "updates contacts created in the given interval as they are marked as dupes" do
            interval = double("some time interval")
            original_contact = double("anonymous contact")
            duplicate = double("anonymous contact")
            contacts = [ original_contact, duplicate ]

            allow(AnonymousContact).to receive(:where).with(created_at: interval).and_return(double(order: contacts))
            allow_any_instance_of(DuplicateDetector).to receive(:duplicate?).with(original_contact).and_return(false)
            allow_any_instance_of(DuplicateDetector).to receive(:duplicate?).with(duplicate).and_return(true)

            expect(duplicate).to receive(:mark_as_duplicate)
            expect(duplicate).to receive(:save!)

            AnonymousContact.deduplicate_contacts_created_between(interval)
          end
        end
      end
    end
  end
end
