class AddUserToMicroposts < ActiveRecord::Migration[7.0]
  def change
    add_reference :microposts, :user, null: false, foreign_key: true
    add_index :microposts, %i(user_id created_at)
  end
end
