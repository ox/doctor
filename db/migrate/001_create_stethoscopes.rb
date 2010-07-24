class CreateStethoscopes < ActiveRecord::Migration
  def self.up
    create_table :stethoscopes do |t|
      t.string :server
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :stethoscopes
  end
end
