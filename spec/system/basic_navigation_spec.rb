require 'rails_helper'

RSpec.describe "Basic Navigation", type: :system do
  before do
    driven_by(:rack_test)
  end

  it "can visit the home page" do
    visit quests_path
    expect(page).to have_content("Your Quests")
  end
  
  it "can navigate to new quest form" do
    visit quests_path
    click_link "New quest"
    expect(page).to have_content("Create New Quest")
  end
  
  it "can navigate to brags page" do 
    visit quests_path
    click_link "My Brags"
    expect(page.current_path).to eq(brags_path)
  end
end 