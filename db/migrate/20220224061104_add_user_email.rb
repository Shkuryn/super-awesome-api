# add column email to users
class AddUserEmail < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :enail, :email
  end
end
