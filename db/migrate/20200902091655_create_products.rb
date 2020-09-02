class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name, null:false, default: ''
      t.integer :number, null:false, default: 1
      t.date :product_created_at, null:false
      t.date :product_expired_at, null:false
      t.text :description
      t.references :user, foreign_key: true
      t.references :container, foreign_key: true

      t.timestamps
    end
  end
end
