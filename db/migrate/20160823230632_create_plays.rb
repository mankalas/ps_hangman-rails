class CreatePlays < ActiveRecord::Migration[5.0]
  def change
    create_table :plays do |t|
      t.belongs_to :player, index: true
      t.belongs_to :game, index: true
      t.timestamps
    end
  end
end
