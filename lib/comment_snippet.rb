require 'active_support/inflector'

class CommentSnippet
  def initialize(data_provider, field_name)
    @data_provider = data_provider
    @field_name = field_name
  end

  def to_s
    pretty_field_name + field_value
  end

  def applies?
    @data_provider.send("#{@field_name}") && !@data_provider.send("#{@field_name}").nil?
  end

  def field_value
    @data_provider.send(@field_name)
  end

  protected
  def pretty_field_name
    "[#{@field_name.to_s.humanize}]\n"
  end
end