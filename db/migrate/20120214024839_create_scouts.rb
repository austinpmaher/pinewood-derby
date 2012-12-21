class CreateScouts < ActiveRecord::Migration
  def change
    create_table :scouts do |t|
      t.string :name
      t.string :car

      t.timestamps
    end
  end
end
