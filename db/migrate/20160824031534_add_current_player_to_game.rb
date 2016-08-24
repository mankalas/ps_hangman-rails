class AddCurrentPlayerToGame < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :current_player_index, :integer, default: 0
  end
end
