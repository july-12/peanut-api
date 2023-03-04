class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.integer :creator_id
      t.text :content
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
  end
end
