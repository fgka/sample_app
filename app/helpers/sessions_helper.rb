module SessionsHelper

  def signed_in?
    !current_user.nil?
  end

  def current_user?(user)
    user == current_user
  end
end
