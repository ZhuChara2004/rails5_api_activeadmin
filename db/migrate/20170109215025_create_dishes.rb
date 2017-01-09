class CreateDishes < ActiveRecord::Migration[5.0]
  def change
    create_table :dishes do |t|
      t.string :title
      t.integer :type
      t.string :components
      t.string :description
      t.decimal :price
      t.belongs_to :restaurant, foreign_key: true

      t.timestamps
    end
  end
end
