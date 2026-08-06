class CreateAds < ActiveRecord::Migration[8.1]
  def change
    create_table :ads do |t|
      t.string :title
      t.text :description
      t.decimal :price
      t.string :category

      t.timestamps
    end
  end
end
