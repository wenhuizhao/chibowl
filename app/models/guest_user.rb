class GuestUser < User
  GUEST_USER_ID = 1
  def id
    GUEST_USER_ID
  end

  def is_guest?
    true
  end
end