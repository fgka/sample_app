class ApplicationController < ActionController::Base

  protect_from_forgery

  include SessionsHelper

  before_filter :authenticate_user!
  before_filter :set_current_tenant # forces milia to set up current tenant

  def authenticate_tenant!()

    unless authenticate_user!
      email = ( params.nil? || params[:user].nil?  ?  ""  : " as: " + params[:user][:email] )

      flash[:notice] = "cannot sign you in#{email}; check email/password and try again"

      return false  # abort the before_filter chain
    end

    # user_signed_in? == true also means current_user returns valid user
    raise SecurityError,"*** invalid sign-in  ***" unless user_signed_in?

    set_current_tenant   # relies on current_user being non-nil

    # any application-specific environment set up goes here

    true  # allows before filter chain to continue
  end

  # Force signout to prevent CSRF attacks
  def handle_unverified_request
    sign_out
    super
  end
end
