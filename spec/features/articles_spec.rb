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

    scenario "should be successful" do
      fill_in "Body", with: "Test body"
      click_button "Create Article"
      expect(page).to have_content("Article was successfully created")
    end

    scenario "should fail" do
      click_button "Create Article"
      expect(page).to have_content("Body can't be blank")
    end
  end

  context "Update article" do
    let(:article) { Article.create(title: "Test title", body: "Test content") }
    before(:each) do
      visit edit_article_path(article)
    end

    scenario "should be successful" do
      within("form") do
        fill_in "Body", with: "New body content"
      end
      click_button "Update Article"
      expect(page).to have_content("Article was successfully updated")
    end

    scenario "should fail" do
      within("form") do
        fill_in "Body", with: ""
      end
      click_button "Update Article"
      expect(page).to have_content("Body can't be blank")
    end
  end

  context "Remove existing article" do
    let!(:article) { Article.create(title: "Test title", body: "Test content") }
    scenario "remove article" do
      visit articles_path
      click_link "Destroy"
      expect(page).to have_content("Article was successfully destroyed")
      expect(Article.count).to eq(0)
    end
  end
end
