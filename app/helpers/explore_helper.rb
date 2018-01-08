module ExploreHelper
  def parse_organisations(organisations)
    orgs = organisations.to_a.map do |org|
      [organisation_title(org), org["slug"]]
    end
    orgs
  end

  def parse_doctypes(document_type_list)
    doctypes = document_type_list.to_a.map do |document_type|
      [document_type.titleize, document_type]
    end
    doctypes
  end

private

  def organisation_title(organisation)
    title = organisation["title"]
    title << " (#{organisation['acronym']})" if organisation["acronym"].present?
    title << " [#{organisation['govuk_status'].titleize}]" if organisation["govuk_status"] && organisation["govuk_status"] != "live"
    title
  end
end
