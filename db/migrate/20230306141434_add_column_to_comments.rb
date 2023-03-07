class AddColumnToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :comment_id, :bigint, foreign_key: true
  end
end
