class Post < ApplicationRecord
  belongs_to :user
  has_many :comments
  validates :title, presence: true, length: {maximum: 100}
  validates :body,  presence: true
  validates :user_id, presence: true
  scope :by_post_id, ->(id) { where(id: id).pluck(:id, :title, :body, :category, :created_at) }
  scope :with_users,    ->(user_id) { where('user_id = ?', user_id).order(created_at: :desc) }
  scope :with_category, ->(category) { where('category = ?', category).order(created_at: :desc) }
  def self.filter(params)
    posts = all
    posts = posts.with_users(params['user_id']) if params['user_id'].present?
    posts = posts.with_category(params['category']) if params['category'].present?
    @posts = posts
  end
end
