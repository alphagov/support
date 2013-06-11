require 'active_support/inflector'

class LabelledSnippet
  def initialize(options)
    @options = options
  end

  def to_s
    comment_label + comment_body
  end

  def applies?
    !applicable_fields.empty?
  end

  protected
  def comment_label
    "[#{label_text}]\n"
  end

  def label_text
    @options[:label] || pretty_field_name
  end

  def pretty_field_name
    @options[:field].to_s.humanize
  end

  def field_names
    @options[:fields] || [@options[:field]]
  end

  def comment_body
    applicable_fields.collect { |field_name| value_of(field_name) }.join("\n")
  end

  def applicable_fields
    field_names.select { |field_name| field_name_applies?(field_name) }
  end

  def value_of(field_name)
    @options[:on].send(field_name)
  end

  def field_name_applies?(field_name)
    @options[:on].respond_to?(field_name) && !value_of(field_name).nil? && !value_of(field_name).empty?
  end
end
