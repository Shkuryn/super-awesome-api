class Comment < ApplicationRecord
  belongs_to :post
  validates :body, presence: true, length: {maximum: 1000}
  validates :user_id, presence: true
  validates :post_id, presence: true
  scope :with_post,   ->(post_id) { where('post_id = ?', post_id) }
end
