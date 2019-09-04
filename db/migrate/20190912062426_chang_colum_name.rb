class ChangColumName < ActiveRecord::Migration[5.1]
  def change
    rename_column :products, :image, :picture
  end
end
