class ApplicationController < ActionController::Base

  protect_from_forgery

  before_filter :authenticate_user!
  before_filter :set_current_tenant # forces milia to set up current tenant

  include SessionsHelper

  # Force signout to prevent CSRF attacks
  def handle_unverified_request
    sign_out
    super
  end

  protected

  def prep_signup_view(tenant=nil, user=nil)
    @user = klass_option_obj( User, user )
    @tenant = klass_option_obj( Tenant, tenant )
    @eula = Eula.get_latest.first
  end

  def klass_option_obj(klass, option_obj)
    return option_obj if option_obj.instance_of?(klass)
    option_obj ||= {} # if nil, makes it empty hash
    return klass.send( :new, option_obj )
  end
end
