class AddColumnToContainer < ActiveRecord::Migration[5.2]
  def change
    add_column :containers, :image, :string
  end
end
