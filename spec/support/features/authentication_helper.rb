module AuthenticationHelper
  def login_with(user = nil, roles = [])
    user ||= FactoryGirl.create(:user)

    roles.each do |r|
      role = Role.find_or_create_by(:name, r)
      User.add_role(role)
    end

    #page.driver.post user_session_path, user: {email: user.email, password: 'password'}

    visit new_user_session_path
    fill_in "user_email", with: user.email
    fill_in "user_password", with: "password"
    click_button "Sign in"
  end
end