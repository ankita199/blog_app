class Article < ApplicationRecord
  belongs_to :user
  has_many :parent_replies, -> (parent_comment_id) { where(parent_comment_id: nil) }, class_name: "Comment",foreign_key: "article_id"
  default_scope -> { order('created_at DESC') }
  
  has_one_attached :attachment
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 140 }
  validates :content, presence: true, length: { minimum: 140 }
end
