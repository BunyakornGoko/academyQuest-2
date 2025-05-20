require 'rails_helper'

RSpec.describe "Quests", type: :system do
  before do
    # Use the configured driver for system tests
    driven_by(:headless_chrome)
  end

  describe "visiting the index page" do
    context "when there are no quests" do
      it "shows a message about no quests" do
        visit quests_path
        
        expect(page).to have_content("No quests found")
        expect(page).to have_selector("[data-testid='no-quests-message']")
        expect(page).to have_selector("[data-testid='new-quest-link']")
      end
    end

    context "when there are quests" do
      let!(:completed_quest) { create(:quest, name: "Completed Quest", status: true) }
      let!(:in_progress_quest) { create(:quest, name: "In Progress Quest", status: false) }

      it "displays all quests with their statuses" do
        visit quests_path
        
        expect(page).to have_content("Your Quests")
        expect(page).to have_selector("[data-testid='quests-list']")
        
        # Check for completed quest
        within("[data-testid='quest-card-#{completed_quest.id}']") do
          expect(page).to have_content("Completed Quest")
          expect(page).to have_content("Completed")
          expect(page).to have_selector("[data-testid='quest-card-name']", text: "Completed Quest")
        end
        
        # Check for in-progress quest
        within("[data-testid='quest-card-#{in_progress_quest.id}']") do
          expect(page).to have_content("In Progress Quest")
          expect(page).to have_content("In Progress")
          expect(page).to have_selector("[data-testid='quest-card-name']", text: "In Progress Quest")
        end
      end
    end
  end

  describe "creating a new quest" do
    it "allows creating a valid quest" do
      visit quests_path
      click_link "New quest", match: :first
      
      expect(page).to have_current_path(new_quest_path)
      expect(page).to have_content("Create New Quest")
      
      fill_in "Name", with: "My E2E Test Quest"
      check "Status"
      
      click_button "Create Quest"
      
      expect(page).to have_content("Quest was successfully created")
      expect(page).to have_content("My E2E Test Quest")
      expect(page).to have_content("Completed")
    end

    it "shows validation errors for invalid quests" do
      visit new_quest_path
      
      fill_in "Name", with: "AB" # Too short
      uncheck "Status" # Status is required
      
      click_button "Create Quest"
      
      expect(page).to have_selector("[data-testid='quest-errors']")
      expect(page).to have_content("Name is too short")
    end
  end

  describe "showing a quest" do
    let!(:quest) { create(:quest, name: "Test Show Quest", status: false) }
    
    it "displays the quest details" do
      visit quests_path
      
      within("[data-testid='quest-card-#{quest.id}']") do
        click_link "View"
      end
      
      expect(page).to have_current_path(quest_path(quest))
      expect(page).to have_content("Test Show Quest")
    end
  end

  describe "editing a quest" do
    let!(:quest) { create(:quest, name: "Original Quest Name", status: false) }
    
    it "allows updating a quest" do
      visit quests_path
      
      find("[data-testid='quest-edit-link-#{quest.id}']").click
      
      expect(page).to have_current_path(edit_quest_path(quest))
      
      fill_in "Name", with: "Updated Quest Name"
      check "Status"
      
      click_button "Update Quest"
      
      expect(page).to have_content("Quest was successfully updated")
      expect(page).to have_content("Updated Quest Name")
      expect(page).to have_content("Completed")
    end
  end

  describe "deleting a quest" do
    let!(:quest) { create(:quest, name: "Quest to Delete", status: false) }
    
    it "allows deleting a quest", js: true do
      visit quests_path
      
      # Store quest count before deletion
      quest_count_before = Quest.count
      
      # Accept the confirmation dialog
      accept_confirm do
        find("[data-testid='quest-delete-button-#{quest.id}']").click
      end
      
      # Wait for deletion to complete
      expect(page).to have_content("Quest was successfully destroyed")
      expect(Quest.count).to eq(quest_count_before - 1)
      expect(page).not_to have_content("Quest to Delete")
    end
  end
end 