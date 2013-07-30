class SessionsController < Devise::SessionsController

  def new
    render 'new'
  end

  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)

    if !resource.nil?
      redirect_to self.resource
    else
      render 'new'
    end
  end

  def destroy
    redirect_path = after_sign_out_path_for(resource_name)
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    respond_to do |format|
      format.all { head :no_content }
      format.any(*navigational_formats) { redirect_to redirect_path }
    end
  end
end
