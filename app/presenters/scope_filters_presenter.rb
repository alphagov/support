require 'gds_api/support_api'

class ScopeFiltersPresenter
  attr_reader :path, :organisation_slug

  def initialize(path: nil, organisation_slug: nil)
    @path = path
    @organisation_slug = organisation_slug
  end

  def filtered?
    path.present? || organisation_slug.present?
  end

  def invalid_filter?
    !filtered?
  end

  def done_page?
    path.present? ? path.start_with?("done", "/done") : false
  end

  def organisation_title
    organisation["title"] if organisation.present?
  end

  def organisation
    @organisation ||= support_api.organisation(organisation_slug) if organisation_slug.present?
  end

  def to_s
    if invalid_filter?
      "Everything"
    else
      [
        organisation_title,
        path
      ].compact.join(' on ')
    end
  end

private

  def support_api
    GdsApi::SupportApi.new(Plek.find("support-api"))
  end
end
