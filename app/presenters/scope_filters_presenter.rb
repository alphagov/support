require 'gds_api/support_api'

class ScopeFiltersPresenter
  attr_reader :path, :organisation_slug

  def initialize(path: nil, organisation_slug: nil)
    @path = normalize_path(path)
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

  def normalize_path(path_or_url)
    return nil unless path_or_url.present?
    normalized_path = URI.parse(path_or_url).path
    if normalized_path.present?
      normalized_path.sub!(/^(http(s)?(:)?(\/)+?(:)?)?((\/)?www.)?gov.uk/, '')
      normalized_path.start_with?('/') ? normalized_path : "/#{normalized_path}"
    else
      '/'
    end
  rescue URI::InvalidURIError
    path_or_url
  end

  def support_api
    GdsApi::SupportApi.new(Plek.find("support-api"))
  end
end
