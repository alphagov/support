class SnippetCollection
  def initialize(snippets)
    @snippets = snippets
  end

  def to_s
    applicable_snippets = @snippets.select(&:applies?)
    applicable_snippets.collect(&:to_s).join("\n\n")
  end
end
