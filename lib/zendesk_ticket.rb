require 'forwardable'
require 'date'
require 'active_support'

class ZendeskTicket
  extend Forwardable

  def initialize(request)
    @request = request
    @requester = request.requester
  end

  def_delegators :@requester, :name, :email, :organisation, :job

  def phone
    remove_space_from_phone_number(@requester.phone)
  end

  def comment
    applicable_snippets = comment_snippets.select(&:applies?)
    applicable_snippets.collect(&:to_s).join("\n\n")
  end

  def not_before_date
    if has_value?(:time_constraint) and has_value?(:not_before_date, @request.time_constraint)
      @request.time_constraint.not_before_date
    else
      nil
    end
  end

  def needed_by_date
    if has_value?(:time_constraint) and has_value?(:needed_by_date, @request.time_constraint)
      @request.time_constraint.needed_by_date
    else
      nil
    end
  end

  def inside_government_tag_if_needed
    @request.inside_government_related? ? ["inside_government"] : []
  end

  private

  def inside_government_tag
    if has_value?(:inside_government) and @request.inside_government == "yes"
      ["inside_government"]
    else
      []
    end
  end
    
  def has_value?(param, target = nil)
    target ||= @request
    target.respond_to?(param) and not target.send(param).blank?
  end

  def remove_space_from_phone_number(number)
    number.gsub(/\s+/, "")
  end
end

