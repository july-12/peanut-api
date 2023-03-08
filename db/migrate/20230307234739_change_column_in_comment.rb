class ChangeColumnInComment < ActiveRecord::Migration[7.0]
  def change
    change_column_null :comments, :post_id, null: true
  end
end
