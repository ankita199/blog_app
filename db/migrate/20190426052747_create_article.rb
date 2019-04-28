class CreateArticle < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.text :content
      t.string :title
      t.references :user
      t.timestamps null: false
    end
  end
end
