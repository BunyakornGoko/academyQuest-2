# spec/features/user_signup_spec.rb
# example of a feature capybara test
require 'rails_helper'

RSpec.feature "User Signup", type: :feature, js: true do
  scenario "User creates a new account" do
    visit new_user_registration_path
    
    fill_in "Email", with: "test@example.com"
    fill_in "Password", with: "password123"
    fill_in "Password confirmation", with: "password123"
    
    click_button "Sign up"
    
    expect(page).to have_content("Welcome! You have signed up successfully.")
    expect(page).to have_current_path(root_path)
  end
end