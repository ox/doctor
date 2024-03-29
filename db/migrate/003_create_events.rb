class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer :status
      t.string :returned
      t.integer :routine_id

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
