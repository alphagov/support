class NameGuesser
  def guess_from_email(email)
    return nil if email.nil?

    local_part = email.split("@")[0]
    if local_part_firstname_dot_lastname?(local_part)
      local_part.split(".").map(&:capitalize).join(" ")
    else
      local_part.capitalize
    end
  end

  protected
  def local_part_firstname_dot_lastname?(local_part)
    local_part.split(".").size == 2
  end
end