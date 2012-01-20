class CreateThings < ActiveRecord::Migration
  def change
    create_table :things do |t|
      t.string :name
      t.text :some_stuff
      t.timestamps
    end
  end
end
