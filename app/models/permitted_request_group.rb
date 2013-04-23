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
    @request_group.request_classes.select { |request_class| @user.can? :modify, request_class }
  end
end