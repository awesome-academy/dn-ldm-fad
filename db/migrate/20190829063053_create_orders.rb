class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.integer :total_price, default: 0
      t.text :description
      t.integer :status, default: 0
      t.references :user, foreign_key: true
      t.string :customer
      t.string :address
      t.string :phone

      t.timestamps
    end
  end
end
