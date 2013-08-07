module SessionsHelper

  def signed_in?
    !current_user.nil?
  end

  def current_user?(user)
    user == current_user
  end

  def current_tenant
    tenant = Tenant.find_by_id(Thread.current[:tenant_id])
  end
end
