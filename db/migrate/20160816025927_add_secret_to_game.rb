class AddSecretToGame < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :secret, :string
  end
end
