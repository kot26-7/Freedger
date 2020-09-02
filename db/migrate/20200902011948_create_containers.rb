class CreateContainers < ActiveRecord::Migration[5.2]
  def change
    create_table :containers do |t|
      t.string :name, null: false, default: ''
      t.string :position, null: false, default: 'Fridge'
      t.text :description
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
