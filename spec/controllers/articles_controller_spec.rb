require "rails_helper"

RSpec.describe ArticlesController, type: :controller do
  context "GET #index" do
    it "returns a success response" do
      get :index
      # expect(response.success).to eq(true)
      expect(response).to be_success
    end
  end

  context "GET #show" do
    let!(:article) { Article.create(title: "Test title", body: "Test body") }
    it "returns a success response" do
      get :show, params: { id: article }
      expect(response).to be_success
    end
  end
end
