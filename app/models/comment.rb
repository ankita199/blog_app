class Comment < ApplicationRecord
  belongs_to :article
  belongs_to :user
  has_one_attached :avatar
  
  class << self
    def replies(parent_comment_id,page)
      child_comments_ids = all_children_recursion(parent_comment_id)
      child_comments_ids << parent_comment_id
      where("parent_comment_id IN (?)",child_comments_ids).order("created_at DESC").paginate(page: page, per_page: 5)
    end
  
    def all_children_recursion(id)
      where(parent_comment_id: id).flat_map do |child_cat|
        all_children_recursion(child_cat.id) << child_cat.id
      end
    end
  end
end
