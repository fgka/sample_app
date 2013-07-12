class SessionsController < Devise::SessionsController

  def new
    render 'new'
  end

  def create
    self.resource = warden.authenticate!(auth_options)
    file = File.open(Rails.root.to_s + "/temp.txt", "w")
    log = "AUTH: #{Time.now} #{self.resource} #{resource_name} #{auth_options}"
    file.puts log
    sign_in(resource_name, resource)

    #    respond_to do |format|
    #      format.html { redirect_to after_sign_in_path_for(resource) }
    #      format.json { render json: { authentication_token: resource.authentication_token } }
    #    end

    if !resource.nil? #&& resource.sign_in_count == 1
      redirect_back_or self.resource
    else
      render 'new'
    end

  end

  def destroy
    #    sign_out
    redirect_path = after_sign_out_path_for(resource_name)
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    respond_to do |format|
      format.all { head :no_content }
      format.any(*navigational_formats) { redirect_to redirect_path }
    end
    redirect_to root_url
  end

  private

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end


end
