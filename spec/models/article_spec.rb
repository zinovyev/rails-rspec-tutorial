require "rails_helper"

RSpec.describe Article, type: :model do
  context "validations tests" do
    it "ensures the title is present" do
      article = Article.new(body: "Content of the body")
      expect(article.valid?).to eq(false)
    end

    it "ensures the body is present" do
      article = Article.new(title: "Title")
      expect(article.valid?).to eq(false)
    end

    it "ensures the article is active by default" do
      article = Article.new(body: "Content of the body", title: "Title")
      expect(article.active?).to eq(true)
    end

    it "should be able to save article" do
      article = Article.new(body: "Content of the body", title: "Title")
      expect(article.save).to eq(true)
    end
  end

  context "scopes tests" do
  end
end
