class PermittedRequestGroups
  include Enumerable

  def initialize(user, request_groups = RequestGroups.new)
    @user = user
    @request_groups = request_groups
  end

  def each(&block)
    wrapped_request_groups = @request_groups.collect { |request_group| PermittedRequestGroup.new(@user, request_group) }
    wrapped_request_groups.select { |request_group| request_group.accessible? }.each(&block)
  end
end

class PermittedRequestGroup
  def initialize(user, request_group)
    @user = user
    @request_group = request_group    
  end

  def accessible?
    not request_classes.empty?
  end

  def title
    @request_group.title
  end

  def request_classes
    @request_group.request_classes.select { |request_class| request_class.accessible_by_user?(@user) }
  end
end