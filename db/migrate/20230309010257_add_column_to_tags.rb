class AddColumnToTags < ActiveRecord::Migration[7.0]
  def change
    add_reference :tags, :course, foreign_key: true
  end
end
