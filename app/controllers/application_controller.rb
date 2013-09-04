class ApplicationController < ActionController::Base

  protect_from_forgery

  include SessionsHelper

  before_filter :authenticate_user!
  before_filter :set_current_tenant

  def authenticate_tenant!()

    unless authenticate_user!
      email = ( params.nil? || params[:user].nil?  ?  ""  : " as: " + params[:user][:email] )
      flash[:notice] = "cannot sign you in#{email}; check email/password and try again"
      return false
    end

    raise SecurityError,"*** invalid sign-in  ***" unless user_signed_in?

    set_current_tenant
    true
  end

  def handle_unverified_request
    sign_out
    super
  end
end
