Given /^I am signed in as a charity worker (un)?related to "(.*?)"$/ do |negate, organization_name|
  organization = Organization.find_by_name(organization_name)
  if negate
    users = User.find_all_by_admin(false)
    user = users.find{|user| user.organization != organization}
  else
    user = organization.users.find{|user| !user.admin?}
  end
  page.set_rack_session("warden.user.user.key" => User.serialize_into_session(user).unshift("User"))
end

Given /^I am signed in as [a\w]?(non-)?admin$/ do |negate|
  user = User.find_by_admin(negate ? false:true)
  page.set_rack_session("warden.user.user.key" => User.serialize_into_session(user).unshift("User"))
end

Given /^I sign up as "(.*?)" with password "(.*?)" and password confirmation "(.*?)"$/ do |email, password,password_confirmation|
  fill_in "Email" , :with => email
  fill_in "user_password" , :with => password
  fill_in "user_password_confirmation" , :with => password_confirmation
  click_button "Sign up"
end

Given /^I sign in as a charity worker with permission to edit "(.*?)"$/ do |name|
  org = Organization.find_by_name name
  org.users   # TODO we will want some habtm to support this eventually
end

And /^I am signed in as the admin using password "(.*?)"$/ do |password|
  admin = User.find_by_admin(true)
  steps %Q{
    Given I am on the sign in page
    And I sign in as "#{admin.email}" with password "#{password}"
  }
end

And /^I am not signed in as the admin using password "(.*?)"$/ do |password|
  admin = User.find_by_admin(false)
  steps %Q{
    Given I am on the sign in page
    And I sign in as "#{admin.email}" with password "#{password}"
  }end

#TODO: Should we bypass mass assgiment in the creation via :without_protection?
Given /^the following users are registered:$/ do |users_table|
  users_table.hashes.each do |user|
    user["admin"] = user["admin"] == "true"
    user["organization"] = Organization.find_by_name(user["organization"])
    worker = User.create! user, :without_protection => true
  end
end

Given /^that I am logged in as any user$/ do
  steps %Q{
     Given the following users are registered:
   | email             | password | confirmed_at         |
   | registered_user@example.com | pppppppp | 2007-01-01  10:00:00 |
  } 
  steps %Q{
    Given I am on the sign in page
    And I sign in as "registered_user@example.com" with password "pppppppp"
  }
end

Then /^I should not be signed in as any user$/ do
  steps %Q{
    Given I am on the new charity page
    Then I should not see "Signed in as"
  }
end

Given /^I am not signed in as any user$/ do
  step "I should not be signed in as any user"
end

When /^I sign out$/ do
  click_link 'Sign Out' 
end

Then /^I should be on the sign in page$/ do
  current_path.should == new_user_session_path
end

Given /^I sign in as "(.*?)" with password "(.*?)"$/ do |email, password|
  fill_in "Email" , :with => email
  fill_in "Password" , :with => password
  click_button "Sign in"
end

Given /^I am on the sign in page$/ do
  steps %Q{ 
    Given I am on the home page
  }
  click_link 'Org Login'
end

Given /^I am on the sign up page$/ do
  steps %Q{ 
    Given I am on the home page
  }
  click_link 'New Org?'
end

Given(/^a user has requested edit privileges for "(.*?)"$/) do |arg1|
    pending # express the regexp above with the code you wish you had
end

When(/^I follow edit_user_path\(nonadmin@myorg\.com\)$/) do
    pending # express the regexp above with the code you wish you had
end

When(/^approve "(.*?)" to edit "(.*?)"$/) do |arg1, arg2|
    pending # express the regexp above with the code you wish you had
end

Then(/^"(.*?)" can edit "(.*?)"$/) do |arg1, arg2|
    pending # express the regexp above with the code you wish you had
end

When(/^do not approve "(.*?)" to edit "(.*?)"$/) do |arg1, arg2|
    pending # express the regexp above with the code you wish you had
end

Then(/^"(.*?)" can not edit "(.*?)"$/) do |arg1, arg2|
    pending # express the regexp above with the code you wish you had
end

Given(/^I am signed in as nonadmin$/) do
    pending # express the regexp above with the code you wish you had
end

end
