class RenameEnail < ActiveRecord::Migration[6.1]
  def change
    change_table :users do |t|
      t.rename :enail, :email
    end
  end
end
