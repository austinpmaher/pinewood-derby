class CreateRaces < ActiveRecord::Migration
  def change
    create_table :races do |t|
      t.integer :heat, :null => false
      t.integer :scout_1_id, :null => false, :options => "REFERENCES scouts(scout_id)"
      t.integer :scout_2_id, :null => false, :options => "REFERENCES scouts(scout_id)"
      t.integer :time1
      t.integer :time2

      t.timestamps
    end
  end
end
