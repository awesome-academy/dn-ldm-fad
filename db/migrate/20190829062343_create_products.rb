class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :image
      t.integer :pire, default: 0
      t.integer :quantity, default: 0
      t.text :description
      t.integer :status, default: 1
      t.references :category, foreign_key: true
      t.references :product_type, foreign_key: true

      t.timestamps
    end
  end
end
