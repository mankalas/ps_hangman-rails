class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
      t.string :name
      t.string :color

      t.timestamps
    end

    create_table :games_players, id: false do |t|
      t.belongs_to :player, index: true
      t.belongs_to :game, index: true
    end
  end
end
