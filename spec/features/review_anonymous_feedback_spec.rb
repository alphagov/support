require "rails_helper"

feature "Reviewing Anonymous Feedback" do
  include GdsApi::TestHelpers::SupportApi

  let(:user) { create :user_who_can_access_everything }

  let(:unreviewed_problem_report_1) do
    {
      "id" => 1,
      "type" => "problem-report",
      "what_wrong" => "Yeti",
      "what_doing" => "Skiing",
      "url" => "http://www.dev.gov.uk/skiing",
      "referrer" => "https://www.gov.uk/browse",
      "user_agent" => "Safari",
      "path" => "/skiing",
      "marked_as_spam" => false,
      "reviewed" => false,
      "created_at" => "2015-01-01T16:00:00.000Z",
    }
  end

  let(:unreviewed_problem_report_2) do
    {
      "id" => 2,
      "type" => "problem-report",
      "what_wrong" => "Sharks",
      "what_doing" => "Swimming",
      "url" => "http://www.dev.gov.uk/swimming",
      "referrer" => "https://www.gov.uk/browse",
      "user_agent" => "Chrome",
      "path" => "/swimming",
      "marked_as_spam" => false,
      "reviewed" => false,
      "created_at" => "2015-01-02T16:00:00.000Z",
    }
  end

  let(:default_problem_report_list) do
    {
      "total_count" => 1,
      "current_page" => 1,
      "pages" => 1,
      "page_size" => 50,
      "from_date" => "2015-01-01",
      "to_date" => "2015-01-03",
      "results" => [
        unreviewed_problem_report_1,
        unreviewed_problem_report_2,
      ],
    }
  end

  before do
    stub_support_api_organisations_list
    stub_support_api_document_type_list
  end

  context "Viewing the table of feedback" do
    let(:reviewed_problem_report_3) do
      {
        "id" => 3,
        "type" => "problem-report",
        "what_wrong" => "Falling",
        "what_doing" => "Climbing",
        "url" => "http://www.dev.gov.uk/climbing",
        "referrer" => "https://www.gov.uk/browse",
        "user_agent" => "Chrome",
        "path" => "/climbing",
        "marked_as_spam" => true,
        "reviewed" => true,
        "created_at" => "2015-01-03T16:00:00.000Z",
      }
    end

    context "with default filtering" do
      before do
        stub_support_api_problem_reports("", default_problem_report_list)

        login_as user

        visit "/"

        click_link "Feedback explorer"
        click_button "Review Anonymous Feedback"
      end

      scenario "Filtered feedback is displayed in the returned order with reviewed excluded" do
        expect(page).to have_content "Review Feedback"

        expect(page).to have_css("tbody tr", count: 2)

        within(:css, "#review-spam-results tbody tr:nth-child(1)") do
          expect(page).to have_content "Yeti"
        end

        within(:css, "#review-spam-results tbody tr:nth-child(2)") do
          expect(page).to have_content "Sharks"
        end
      end
    end

    context "when filtered to include reviewed feedback" do
      let(:problem_report_list) do
        {
          "total_count" => 1,
          "current_page" => 1,
          "pages" => 1,
          "page_size" => 50,
          "from_date" => "2015-01-01",
          "to_date" => "2015-01-03",
          "results" => [
            unreviewed_problem_report_1,
            unreviewed_problem_report_2,
            reviewed_problem_report_3,
          ],
        }
      end

      before do
        stub_support_api_problem_reports("", default_problem_report_list)
        stub_support_api_problem_reports("include_reviewed=true", problem_report_list)

        login_as user

        visit "/"

        click_link "Feedback explorer"
        click_button "Review Anonymous Feedback"

        check "include_reviewed"
        click_button "Filter"
      end

      scenario "Filtered feedback is displayed in the returned order" do
        expect(page).to have_css("tbody tr", count: 3)

        within(:css, "#review-spam-results tbody tr:nth-child(1)") do
          expect(page).to have_content "Yeti"
        end

        within(:css, "#review-spam-results tbody tr:nth-child(2)") do
          expect(page).to have_content "Sharks"
        end

        within(:css, "#review-spam-results tbody tr:nth-child(3)") do
          expect(page).to have_content "Falling"
        end
      end

      scenario "reports that were marked for spam is indicated" do
        within(:css, "#review-spam-results tbody tr:nth-child(1)") do
          expect(page.find('input[type="checkbox"]')).to_not be_checked
        end

        within(:css, "#review-spam-results tbody tr:nth-child(3)") do
          expect(page.find('input[type="checkbox"]')).to be_checked
        end
      end

      scenario "Reviewed feedback has a specific class applied" do
        within(:css, "#review-spam-results tbody .reviewed") do
          expect(page).to have_content "Falling"
        end
      end
    end

    context "when date filters are applied" do
      let(:problem_report_list) do
        {
          "total_count" => 1,
          "current_page" => 1,
          "pages" => 1,
          "page_size" => 50,
          "from_date" => "2015-01-01",
          "to_date" => "2015-01-01",
          "results" => [
            unreviewed_problem_report_1,
          ],
        }
      end

      before do
        stub_support_api_problem_reports("", problem_report_list)
        stub_support_api_problem_reports("from_date=1%20Sep%202016&to_date=1%20Sep%202016", problem_report_list)

        login_as user

        visit "/"

        click_link "Feedback explorer"
        click_button "Review Anonymous Feedback"

        fill_in "from_date", with: "1 Sep 2016"
        fill_in "to_date", with: "1 Sep 2016"

        click_button "Filter"
      end

      scenario "Filtered feedback is displayed " do
        expect(page).to have_css("tbody tr", count: 1)

        within(:css, "#review-spam-results tbody tr:nth-child(1)") do
          expect(page).to have_content "Yeti"
        end
      end
    end

    context "when there are multiple pages of results" do
      let(:first_problem_report_list_page) do
        {
          "total_count" => 1,
          "current_page" => 1,
          "pages" => 2,
          "page_size" => 1,
          "from_date" => "2015-01-01",
          "to_date" => "2015-01-03",
          "results" => [
            unreviewed_problem_report_1,
          ],
        }
      end

      let(:second_problem_report_list_page) do
        {
          "total_count" => 1,
          "current_page" => 2,
          "pages" => 2,
          "page_size" => 1,
          "from_date" => "2015-01-01",
          "to_date" => "2015-01-03",
          "results" => [
            unreviewed_problem_report_2,
          ],
        }
      end

      before do
        stub_support_api_problem_reports("", first_problem_report_list_page)
        stub_support_api_problem_reports("page=2", second_problem_report_list_page)

        login_as user

        visit "/"

        click_link "Feedback explorer"
        click_button "Review Anonymous Feedback"
      end

      scenario "the results are paginated" do
        expect(page).to have_css("tbody tr", count: 1)

        within(:css, "#review-spam-results tbody tr:nth-child(1)") do
          expect(page).to have_content "Yeti"
        end

        within(page.first(".pagination")) do
          click_link "2"
        end

        expect(page).to have_css("tbody tr", count: 1)

        within(:css, "#review-spam-results tbody tr:nth-child(1)") do
          expect(page).to have_content "Sharks"
        end
      end
    end
  end

  context "when marking feedback items as spam" do
    let(:unreviewed_problem_report_3) do
      {
        "id" => 3,
        "type" => "problem-report",
        "what_wrong" => "Falling",
        "what_doing" => "Climbing",
        "url" => "http://www.dev.gov.uk/climbing",
        "referrer" => "https://www.gov.uk/browse",
        "user_agent" => "Chrome",
        "path" => "/climbing",
        "marked_as_spam" => true,
        "reviewed" => true,
        "created_at" => "2015-01-03T16:00:00.000Z",
      }
    end

    let(:first_unreviewed_problem_report_list_page) do
      {
        "total_count" => 3,
        "current_page" => 1,
        "pages" => 2,
        "page_size" => 2,
        "from_date" => "2015-01-01",
        "to_date" => "2015-01-03",
        "results" => [
          unreviewed_problem_report_1,
          unreviewed_problem_report_2,
        ],
      }
    end

    let(:second_unreviewed_problem_report_list_page) do
      {
        "total_count" => 3,
        "current_page" => 2,
        "pages" => 2,
        "page_size" => 2,
        "from_date" => "2015-01-01",
        "to_date" => "2015-01-03",
        "results" => [
          unreviewed_problem_report_3,
        ],
      }
    end

    let(:params) { { "1" => "true", "2" => "false" } }

    scenario "that feedback is submitted and the next list is shown" do
      login_as user

      visit "/"

      click_link "Feedback explorer"

      first_stub_request = stub_support_api_problem_reports("", first_unreviewed_problem_report_list_page)

      click_button "Review Anonymous Feedback"

      expect(first_stub_request).to have_been_made

      expect(page).to have_css("tbody tr", count: 2)

      within(:css, "#review-spam-results tbody tr:nth-child(1)") do
        check("mark_as_spam_1")
      end

      WebMock.reset!

      second_stub_request = stub_support_api_problem_reports("", second_unreviewed_problem_report_list_page)
      reviewed_request = stub_support_api_mark_reviewed_for_spam(params, "success" => true)

      click_button "Save"

      expect(second_stub_request).to have_been_made
      expect(reviewed_request).to have_been_made

      expect(page).to have_css("tbody tr", count: 1)

      within(:css, "#review-spam-results tbody tr:nth-child(1)") do
        expect(page).to have_content "Climbing"
      end
    end
  end

  context "when filters are applied at the same time as reviewing" do
    let(:problem_report_list) do
      {
        "total_count" => 1,
        "current_page" => 1,
        "pages" => 1,
        "page_size" => 50,
        "from_date" => "2015-01-01",
        "to_date" => "2015-01-01",
        "results" => [
          unreviewed_problem_report_1,
        ],
      }
    end

    before do
      stub_support_api_problem_reports("", problem_report_list)
      stub_support_api_problem_reports("from_date=1%20Sep%202016&to_date=1%20Sep%202016", problem_report_list)
      stub_support_api_mark_reviewed_for_spam({ "1" => "true" }, "success" => "true")
      stub_support_api_problem_reports("include_reviewed=true&from_date=1%20Sep%202016&to_date=1%20Sep%202016", problem_report_list)

      login_as user

      visit "/"

      click_link "Feedback explorer"
      click_button "Review Anonymous Feedback"

      fill_in "from_date", with: "1 Sep 2016"
      fill_in "to_date", with: "1 Sep 2016"

      check "include_reviewed"

      click_button "Filter"

      within(:css, "#review-spam-results tbody tr:nth-child(1)") do
        check("mark_as_spam_1")
      end

      click_button "Save"
    end

    scenario "the table view following a review applies those same filters" do
      expect(page.find("#start-date").value).to eq "1 Sep 2016"
      expect(page.find("#end-date").value).to eq "1 Sep 2016"

      expect(page).to have_css("tbody tr", count: 1)

      within(:css, "#review-spam-results tbody tr:nth-child(1)") do
        expect(page).to have_content "Yeti"
      end
    end
  end
end
