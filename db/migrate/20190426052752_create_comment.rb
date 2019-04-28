class CreateComment < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.references :article
      t.references :user
      t.references :parent_comment
      t.string :content
      t.timestamps null: false
    end
  end
end
