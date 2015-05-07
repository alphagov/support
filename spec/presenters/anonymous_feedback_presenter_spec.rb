require 'rails_helper'

describe AnonymousFeedbackPresenter, type: :presenter do
  context "when api_response has no `results`" do
    let(:api_response) { {"results" => []} }
    let(:presenter) { AnonymousFeedbackPresenter.new(api_response) }

    describe "#empty?" do
      it "should be empty" do
        expect(presenter).to be_empty
      end
    end

    describe "#size" do
      it "should be zero" do
        expect(presenter.size).to be_zero
      end
    end

    describe "contents" do
      it "should present api_response's `results`" do
        expect(presenter).to eq([])
      end
    end
  end

  context "when api_response has `results`" do
    let(:long_form_contact) { {"type" => "long_form_contact"} }
    let(:problem_report) { { "type" => "problem_report" } }
    let(:service_feedback) { { "type" => "service_feedback" } }
    let(:current_page) { 2 }
    let(:pages) { 9 }
    let(:page_size) { 50 }
    let(:api_response) {
      {
        "current_page" => current_page,
        "pages" => pages,
        "page_size" => page_size,
        "results" => [
          long_form_contact,
          problem_report,
          service_feedback,
        ]
      }
    }
    let(:presenter) { AnonymousFeedbackPresenter.new(api_response) }

    describe "#size" do
      it "should match api_response's `results`" do
        expect(presenter.size).to eql(api_response["results"].size)
      end
    end

    describe "contents" do
      it "should present api_response's `results`" do
        expect(presenter).to contain_exactly(
          an_instance_of(LongFormContactPresenter),
          an_instance_of(ProblemReportPresenter),
          an_instance_of(ServiceFeedbackPresenter),
        )
      end
    end

    describe "pagination" do
      it "should report `current_page`" do
        expect(presenter.current_page).to eq(current_page)
      end

      it "should report `total_pages`" do
        expect(presenter.total_pages).to eq(pages)
      end

      it "should report `limit_value`" do
        expect(presenter.limit_value).to eq(page_size)
      end
    end
  end
end
