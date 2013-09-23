Given /^I am logged in as a user$/ do
  @current_user = FactoryGirl.create(:user)
  login_as(@current_user, scope: :user)
end