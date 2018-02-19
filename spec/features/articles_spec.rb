require 'rails_helper'

RSpec.feature "Articles", type: :feature do
  context "Create new article" do
    scenario "Should be successful" do
      visit new_article_path
      within("form") do
        fill_in "Title", with: "Test title"
        fill_in "Body", with: "Test body"
        check "Active"
      end
      click_button "Create Article"
      expect(page).to have_content("Article was successfully created")
    end

    scenario "Should fail" do

    end
  end

  context "Update article" do

  end

  context "Remove existing article" do

  end
end
