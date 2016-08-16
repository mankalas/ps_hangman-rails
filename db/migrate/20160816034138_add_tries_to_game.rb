class AddTriesToGame < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :tries, :string, default: ''
  end
end
