class CreateRoutines < ActiveRecord::Migration
  def self.up
    create_table :routines do |t|
      t.string :name
      t.integer :stethoscope_id

      t.timestamps
    end
  end

  def self.down
    drop_table :routines
  end
end
