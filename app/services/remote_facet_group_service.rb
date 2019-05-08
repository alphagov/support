require 'services'

class RemoteFacetGroupService
  def find(content_id)
    expanded_facet_group(content_id).to_hash
  end

private

  def expanded_facet_group(content_id)
    publishing_api.get_expanded_links(content_id)
  end

  def publishing_api
    Services.publishing_api
  end
end
