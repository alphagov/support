module NameHelper
  def name_for(form, fields)
    return nil if form.object_name.blank?
    return nil if fields.blank?

    "#{form.object_name}#{fields.map { |field| "[#{field}]" }.join}"
  end
end
