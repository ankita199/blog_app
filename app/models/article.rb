class Article < ApplicationRecord
  SIZE = { small: "50x50" }
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :parent_replies, -> (parent_comment_id) { where(parent_comment_id: nil) }, class_name: "Comment",foreign_key: "article_id"
  default_scope -> { order('created_at DESC') }
  
  has_one_attached :attachment
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 140 }
  validates :content, presence: true, length: { minimum: 140 }
  validates :attachment, presence: true

  def attachment_image
    attachment.attached? ? attachment : "default_blog.png" rescue "default_blog.png"
  end
end
