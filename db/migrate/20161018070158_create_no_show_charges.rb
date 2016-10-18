class CreateNoShowCharges < ActiveRecord::Migration[5.0]
  def change
    create_table :no_show_charges do |t|
      t.references :booking
      t.integer :price

      t.timestamps
    end
  end
end
