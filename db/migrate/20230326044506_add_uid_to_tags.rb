class AddUidToTags < ActiveRecord::Migration[7.0]
  def change
    add_column :tags, :uid, :string
    add_index :tags, :uid
    add_column :posts, :uid, :string
    add_index :posts, :uid
    add_column :comments, :uid, :string
    add_index :comments, :uid
    add_column :posts, :type, :string
  end
end
