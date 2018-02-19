class MakeArticleActiveByDefault < ActiveRecord::Migration[5.1]
  def change
    change_column :articles, :active, :boolean, default: true
  end
end
