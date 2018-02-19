require "rails_helper"

RSpec.feature "Visiting the homepage", type: :feature do
  scenario "The visitor should see a welcome message" do
    visit root_path
    expect(page).to have_text("Welcome to my blog!")
  end
end
