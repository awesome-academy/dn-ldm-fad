class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.integer :type_payment, default: 0
      t.references :order, foreign_key: true

      t.timestamps
    end
  end
end
