class CreateLessons < ActiveRecord::Migration[5.0]
  def change
    create_table :lessons do |t|
      t.datetime :starts_at
      t.integer :duration_in_minutes
      t.string :description

      t.timestamps
    end
  end
end
