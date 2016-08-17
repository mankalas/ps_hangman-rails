class AddLivesToGames < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :lives, :integer, default: 6
  end
end
