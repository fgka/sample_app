include ApplicationHelper

def valid_signin(user)
  fill_in 'user_email', with: user.email
  fill_in 'user_password', with: user.password
  click_button 'Sign in'
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert', text: message)
  end
end

def sign_in(user)
  begin 
    find_link('Sign out').click    
  rescue
  end
  visit new_user_session_path
  fill_in 'user_email', with: user.email
  fill_in 'user_password', with: user.password
  click_button 'Sign in'
end
