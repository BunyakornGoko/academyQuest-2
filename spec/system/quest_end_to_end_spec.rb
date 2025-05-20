require 'rails_helper'

RSpec.describe "Quests E2E", type: :system do
  before do
    # Force the driver to rack_test for basic functionality tests
    driven_by(:rack_test)
  end

  it "completes the full quest lifecycle" do
    # Step 1: Visit the quests index page
    visit quests_path
    expect(page).to have_content("Your Quests")
    
    # Step 2: Navigate to the new quest form
    click_link "New quest"
    expect(page).to have_current_path(new_quest_path)
    expect(page).to have_content("Create New Quest")
    
    # Step 3: Fill in quest details and submit
    fill_in "Name", with: "Complete Rails E2E Test"
    uncheck "Status" # Start as in-progress
    click_button "Create Quest"
    
    # Step 4: Verify we're redirected to the show page with success message
    expect(page).to have_content("Quest was successfully created")
    expect(page).to have_content("Complete Rails E2E Test")
    expect(page).to have_content("In Progress")
    
    # Store the quest ID for later use
    quest = Quest.find_by(name: "Complete Rails E2E Test")
    
    # Step 5: Navigate back to index page
    click_link "Back to quests"
    expect(page).to have_current_path(quests_path)
    
    # Step 6: Verify the new quest appears in the list
    within("[data-testid='quest-card-#{quest.id}']") do
      expect(page).to have_content("Complete Rails E2E Test")
      expect(page).to have_content("In Progress")
    end
    
    # Step 7: Navigate to edit page
    within("[data-testid='quest-card-#{quest.id}']") do
      find("[data-testid='quest-edit-link-#{quest.id}']").click
    end
    expect(page).to have_current_path(edit_quest_path(quest))
    
    # Step 8: Update the quest
    fill_in "Name", with: "Completed Rails E2E Test"
    check "Status" # Mark as completed
    click_button "Update Quest"
    
    # Step 9: Verify update was successful
    expect(page).to have_content("Quest was successfully updated")
    expect(page).to have_content("Completed Rails E2E Test")
    expect(page).to have_content("Completed")
    
    # Step 10: Go back to index and verify changes
    click_link "Back to quests"
    within("[data-testid='quest-card-#{quest.id}']") do
      expect(page).to have_content("Completed Rails E2E Test")
      expect(page).to have_content("Completed")
      expect(page).to have_css(".line-through") # Name should be crossed out
    end
    
    # Step 11: Delete the quest - we need to modify this for rack_test
    # since it doesn't support JS dialogs
    page.find("[data-testid='quest-delete-button-#{quest.id}']").click
    
    # Step 12: Verify quest was deleted
    expect(page).to have_content("Quest was successfully destroyed")
    expect(page).not_to have_content("Completed Rails E2E Test")
    
    # Step 13: Create another quest and test other workflows
    click_link "New quest"
    
    # Invalid quest - test validation
    fill_in "Name", with: "AB" # Too short
    click_button "Create Quest"
    
    # Verify error message
    expect(page).to have_content("Name is too short")
    
    # Fix error and submit again
    fill_in "Name", with: "Another Valid Quest"
    check "Status"
    click_button "Create Quest"
    
    # Verify successful creation
    expect(page).to have_content("Quest was successfully created")
    expect(page).to have_content("Another Valid Quest")
    
    # Test the "My Brags" link
    visit quests_path
    click_link "My Brags"
    expect(page).to have_current_path(brags_path)
    
    # Go back to quests
    visit quests_path
    expect(page).to have_content("Your Quests")
  end
end 