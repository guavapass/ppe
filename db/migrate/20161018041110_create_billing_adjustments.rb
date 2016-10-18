class CreateBillingAdjustments < ActiveRecord::Migration[5.0]
  def change
    create_table :billing_adjustments do |t|
      t.references :booking, foreign_key: true
      t.integer :price

      t.timestamps
    end
  end
end
