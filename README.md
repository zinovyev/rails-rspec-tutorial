# Testing Rails with RSpec

Beginners introduction to testing Ruby On Rails application with RSpec and Capybara.


## Install Rails with RSpec (v0.1)


1. Install rails without `minitest`: `rails new rails-rspec-tutorial -T`;

2. Add `rspec` to `Gemfile`:

```ruby

  group :development, :test do
    gem 'rspec-rails', '~> 3.7'
  end

```

3. Install dependencies: `bundle install`;

4. Execute `bundle exec rails generate rspec:install` to create a `/spec` dir;

5. Run rspec: `bundle exec rspec`


## Your first spec (v0.2)


1. Create first spec:

```ruby

require "rails_helper"

RSpec.describe "hello spec" do
  describe "math" do
    expect(6 * 7).to eq(43)
  end
end

```

2. And catch an error:

```

Failures:

  1) hello spec math should be able to perform basic math
     Failure/Error: expect(6 * 7).to eq(43)
     
       expected: 43
            got: 42


```

3. Fix the error to get test passed:

```ruby

require "rails_helper"

RSpec.describe "hello spec" do
  describe "math" do
    it "should be able to perform basic math" do
      # expect(6 * 7).to eq(43) # => false
      expect(6 * 7).to eq(42)
    end
  end
end

```

4. Add another spec with empty string:

```ruby

require "rails_helper"

RSpec.describe "hello spec" do
  # ...
  describe String do
    let(:string) { String.new }
    it "should provide an empty string" do
      expect(string).to eq("")
    end
  end
end

```


## Create a unit test for Article model (v0.3)


1. Create model `Article`:

```bash

bundle exec rails g model Article title:string body:text active:boolean

RAILS_ENV=test bundle exec rake db:migrate

```

2. Create `spec/models/article_spec.rb`:

```ruby

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

```

3. Add some presence validators to `app/models/article.rb`:

```ruby

class Article < ApplicationRecord
  validates_presence_of :title, :body
end

```

4. Create a migration:

```ruby

class MakeArticleActiveByDefault < ActiveRecord::Migration[5.1]
  def change
    change_column :articles, :active, :boolean, default: true
  end
end

```

5. Run migration:

```bash

bundle exec rake db:migrate

```

6. Add scope specs:

```ruby

require "rails_helper"

RSpec.describe Article, type: :model do
  # ...

  context "scopes tests" do
    let(:params) { { body: "Content of the body", title: "Title", active: true } }
    before(:each) do
      Article.create(params)
      Article.create(params)
      Article.create(params)
      Article.create(params.merge(active: false))
      Article.create(params.merge(active: false))
    end

    it "should return all active articles" do
      expect(Article.active.count).to eq(3)
    end

    it "should return all inactive articles" do
      expect(Article.inactive.count).to eq(2)
    end
  end
end

```


##  Create functional test for Articles controller (v0.4)


1. Create Articles controller scaffold:

```bash

bundle exec rails g scaffold_controller Articles

rm -rf spec/views spec/routing spec/request spec/helpers spec/requests

```

2. Create Articles spec:

```ruby

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

```

3. Add articles to `routes.rb` file:

```ruby

Rails.application.routes.draw do
  resources :articles
end

```

4. Add `--format documentation` to `.rspec`


## Create integration spec and a home page (v0.5)


1. Add Capybara to `Gemfile`:

```ruby

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 3.7'
  gem 'capybara'
end

```

2. Add these lines to your `spec/rails_helper.rb` file:

```ruby

require 'capybara/rails'
require 'capybara/rspec'

```

3. Create first feature test by running `bundle exec rails g rspec:feature home_page`:

```ruby

require "rails_helper"

RSpec.feature "Visiting the homepage", type: :feature do
  scenario "The visitor should see a welcome message" do
    visit root_path
    expect(page).to have_text("Welcome to my blog!")
  end
end

```

4. Add `root` to `routes.rb`:

```ruby

Rails.application.routes.draw do
  root "home#index"
  resources :articles
end

```

5. Generate controller:

```ruby

bundle exec rails g controller Home index

rm -rf spec/controllers/home_controller_spec.rb spec/views/home spec/views/home/index.html.erb_spec.rb spec/helpers/home_helper_spec.rb

```

6. Modify the view `app/views/home/index.html.erb`:

```erb

<h1>Welcome to my blog!</h1>
<p>Find me in app/views/home/index.html.erb</p>

```


## Create integration spec for Articles v0.6


1. `bundle exec rails g rspec:feature articles`

2. Create feature spec:

```ruby

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
      expect(page).to have_content("Article successfully created")
    end

    scenario "Should fail" do

    end
  end

  context "Update article" do

  end

  context "Remove existing article" do

  end
end

```

3. Fix the view (`app/views/articles/_form.erb`):

```erb

<%= form_with(model: article, local: true) do |form| %>
  <% if article.errors.any? %>
    <div id="error_explanation">
      <h2><%= pluralize(article.errors.count, "error") %> prohibited this article from being saved:</h2>

      <ul>
      <% article.errors.full_messages.each do |message| %>
        <li><%= message %></li>
      <% end %>
      </ul>
    </div>
  <% end %>

  <div>
    <%= form.label :title %> 
    <%= form.text_field :title, id: "article_title" %> 
  </div>

  <div>
    <%= form.label :body %> 
    <%= form.text_area :body, id: "article_body" %> 
  </div>

  <div>
    <%= form.label :active %> 
    <%= form.check_box :active, id: "article_active" %> 
  </div>

  <div class="actions">
    <%= form.submit %>
  </div>
<% end %>

```

4. Allow attributes in `app/controllers/articles_controller.rb`:

```ruby

def article_params
  params.require(:article).permit(:active, :id, :title, :body)
end

```

5. Full Articles test:

```ruby

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

```


## Add Selenium web driver (v0.7): 


1. Add to `Gemfile`:

```ruby

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 3.7'
  gem 'capybara'
  gem 'selenium-webdriver'
end

```

2. Add to `spec/rspec_helper.rb`:

```ruby

Capybara.default_driver = :selenium_chrome_headless

```

3. Fix articles spec:

```ruby

context "Remove existing article" do
  let!(:article) { Article.create(title: "Test title", body: "Test content") }
  scenario "remove article" do
    visit articles_path
    expect(Article.count).to eq(1)
    accept_alert do
      click_link "Destroy"
    end
    expect(page).to have_content("Article was successfully destroyed")
    expect(Article.count).to eq(0)
  end
end


```


## Add simplecov gem (v0.8):


1. Rails coverage report: `bundle exec rails stats`

2. To install codecov add to your `Gemfile`:

```ruby

gem 'simplecov', require: false, group: :test

```

3. Add to your `spec/rails_helper.rb`:

```ruby

require 'simplecov'
SimpleCov.start

```

4. Don't forget to add `coverage/` dir to your `.gitignore` file;


## Helpful links:


* https://relishapp.com/rspec/rspec-rails/docs

* https://github.com/teamcapybara/capybara

* https://github.com/colszowka/simplecov

* http://www.betterspecs.org/ 

* https://github.com/thoughtbot/factory_bot

* https://github.com/ffaker/ffaker
