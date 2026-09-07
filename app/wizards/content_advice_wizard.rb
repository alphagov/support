# frozen_string_literal: true

class ContentAdviceWizard
  include DfE::Wizard

  def steps_processor
    DfE::Wizard::StepsProcessor::Graph.draw(self, predicate_caller: state_store) do |graph|
      # Register all steps
      graph.add_node :request_type, Steps::ContentAdvice::RequestTypeStep
      graph.add_node :short_url, Steps::ContentAdvice::ShortUrlStep
      graph.add_node :organisation_page, Steps::ContentAdvice::OrganisationPageStep
      graph.add_node :common_info, Steps::ContentAdvice::CommonInfoStep
      graph.add_node :review, Steps::ContentAdvice::ReviewStep

      # Set starting step
      graph.root :request_type

      graph.add_multiple_conditional_edges(
        from: :request_type,
        branches: [
          { when: :short_url_request?, then: :short_url },
          { when: :org_page_request?, then: :organisation_page },
        ],
        default: :common_info,
      )

      graph.add_edge from: :short_url, to: :common_info
      graph.add_edge from: :organisation_page, to: :common_info
      graph.add_edge from: :common_info, to: :review
    end
  end

  def route_strategy
    DfE::Wizard::RouteStrategy::NamedRoutes.new(
      wizard: self,
      namespace: "content-advice",
    )
  end

  def inspect
    # Define inspector for development - useful for debug (see Optional Features)
    DfE::Wizard::Tooling::Inspect.new(wizard: self) if Rails.env.development?
  end

  def logger
    # Define logger for development - useful for debug (see Optional Features)
    DfE::Wizard::Logging::Logger.new(Rails.logger) if Rails.env.development?
  end
end
