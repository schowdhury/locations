class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string :lat
      t.string :lon
      t.string :description
      t.timestamps
    end
  end

  def self.down
    drop_table :locations
  end
end
