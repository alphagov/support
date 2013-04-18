require 'ostruct'

class StubUser < OpenStruct
  def has_permission?(perm)
    return true if perms.nil?
    perms.include?(perm)
  end
end