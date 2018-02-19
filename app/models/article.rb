class Article < ApplicationRecord
  validates_presence_of :title, :body
  scope :active, ->() { where(active: true) }
  scope :inactive, ->() { where(active: false) }
end
