include ApplicationHelper

def valid_signin(user)
  fill_in "user_email", with: user.email
  fill_in "user_password", with: user.password
  click_button "Sign in"
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert', text: message)
  end
end

def sign_in(user)
  begin
    find_link("Sign out").click
  rescue
  end
  visit new_user_session_path
  fill_in "user_email", with: user.email
  fill_in "user_password", with: user.password
  click_button "Sign in"
end

def set_tenant( tenant )
  Thread.current[:tenant_id]  = tenant.id
end

def current_tenant()
  return Thread.current[:tenant_id]
end

def reset_tenant()
  Thread.current[:tenant_id]  = nil   # starting point; no tenant
end

def void_tenant()
  Thread.current[:tenant_id]  = 0   # an impossible tenant
end

