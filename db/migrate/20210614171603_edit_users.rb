class EditUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :password, :password
    add_column :users, :password_digest, :string
  end
end
