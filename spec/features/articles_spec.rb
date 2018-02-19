require 'rails_helper'

RSpec.feature "Articles", type: :feature do
  context "Create new article" do
    before(:each) do
      visit new_article_path
      within("form") do
        fill_in "Title", with: "Test title"
        check "Active"
      end
    end

    scenario "Should be successful" do
      fill_in "Body", with: "Test body"
      click_button "Create Article"
      expect(page).to have_content("Article was successfully created")
    end

    scenario "Should fail" do
      click_button "Create Article"
      expect(page).to have_content("Body can't be blank")
    end
  end

  context "Update article" do

  end

  context "Remove existing article" do

  end
end
