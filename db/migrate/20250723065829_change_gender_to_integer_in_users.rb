class ChangeGenderToIntegerInUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :gender, :string
    add_column :users, :gender, :integer
  end
end
