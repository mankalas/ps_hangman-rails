class CreatePlays < ActiveRecord::Migration[5.0]
  def change
    create_table :plays do |t|
      t.belongs_to :game
      t.belongs_to :player
      t.integer :lives, default: 6
      t.boolean :active, default: false

      t.timestamps
    end
  end
end
