class AddColumnToTag < ActiveRecord::Migration[7.0]
  def change
    add_column :tags, :creator_id, :bigint, foreign_key: true
  end
end
