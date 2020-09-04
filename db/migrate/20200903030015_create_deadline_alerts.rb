class CreateDeadlineAlerts < ActiveRecord::Migration[5.2]
  def change
    create_table :deadline_alerts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :container, foreign_key: true
      t.references :product, foreign_key: true
      t.string :action, null: false

      t.timestamps
    end
  end
end
