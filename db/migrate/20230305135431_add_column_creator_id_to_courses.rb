class AddColumnCreatorIdToCourses < ActiveRecord::Migration[7.0]
  def change
    add_reference :courses, :creator, foreign_key: { to_table: :users }, index: true
  end
end
