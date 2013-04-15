class StubUser
  def initialize(perms)
    @perms = perms
  end

  def has_permission?(perm)
    @perms.include?(perm)
  end
end