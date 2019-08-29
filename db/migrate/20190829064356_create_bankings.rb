class CreateBankings < ActiveRecord::Migration[5.1]
  def change
    create_table :bankings do |t|
      t.string :account_number
      t.string :full_name
      t.string :user_name
      t.string :password

      t.timestamps
    end
  end
end
