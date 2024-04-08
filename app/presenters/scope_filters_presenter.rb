require "gds_api/support_api"

class ScopeFiltersPresenter
  attr_reader :organisation_slug, :document_type, :path_set_id

  def initialize(paths: nil, path_set_id: nil, organisation_slug: nil, document_type: nil)
    @parsed_paths = normalize_paths(paths)
    @organisation_slug = organisation_slug
    @document_type = document_type
    @path_set_id = path_set_id
  end

  def paths
    @paths ||= parsed_paths.join(", ") if parsed_paths.present?
  end

  def paths_for_api
    @paths_for_api ||= parsed_paths
  end

  def filtered?
    paths.present? || organisation_slug.present? || document_type.present?
  end

  def invalid_filter?
    !filtered?
  end

  def done_page?
    parsed_paths.present? && parsed_paths.any? { |path| path.start_with?("done", "/done") }
  end

  def organisation_title
    organisation["title"] if organisation.present?
  end

  def document_type_title
    "Document type: #{document_type.titleize.downcase}" if document_type.present?
  end

  def paths_title
    if parsed_paths.present?
      if parsed_paths.count > 2
        "#{parsed_paths.first} and #{parsed_paths.count - 1} other paths"
      elsif parsed_paths.count == 2
        "#{parsed_paths.first} and 1 other path"
      else
        paths
      end
    end
  end

  def organisation
    @organisation ||= support_api.organisation(organisation_slug) if organisation_slug.present?
  end

  def to_s
    if invalid_filter?
      "Everything"
    elsif paths.present?
      result = [
        organisation_title,
        paths_title,
      ].compact.join(" on ")
      document_type_title.present? ? "#{result} - #{document_type_title}" : result
    elsif organisation_title.present?
      document_type_title.present? ? "#{organisation_title} - #{document_type_title}" : organisation_title
    elsif document_type_title.present?
      document_type_title
    else
      ""
    end
  end

private

  attr_reader :parsed_paths

  def normalize_path(path_or_url)
    if path_or_url.present?
      normalized_path = URI.parse(path_or_url).path

      if normalized_path.present?
        normalized_path.sub!(/\A(http(s)?(:)?(\/)+?(:)?)?((\/)?www\.)?gov\.uk/, "")
        normalized_path.start_with?("/") ? normalized_path : "/#{normalized_path}"
      else
        "/"
      end
    else
      "/"
    end
  rescue URI::InvalidURIError
    path_or_url
  end

  def normalize_paths(paths_or_urls)
    return nil if paths_or_urls.blank?

    result = paths_or_urls.compact.map(&:strip).map { |path_or_url| normalize_path(path_or_url) }.uniq
    result.empty? ? ["/"] : result
  end

  def support_api
    GdsApi::SupportApi.new(
      Plek.find("support-api"),
      bearer_token: ENV["SUPPORT_API_BEARER_TOKEN"],
    )
  end
end
