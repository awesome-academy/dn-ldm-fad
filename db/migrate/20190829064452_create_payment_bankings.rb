class CreatePaymentBankings < ActiveRecord::Migration[5.1]
  def change
    create_table :payment_bankings do |t|
      t.references :payment, foreign_key: true
      t.references :banking, foreign_key: true

      t.timestamps
    end
  end
end
