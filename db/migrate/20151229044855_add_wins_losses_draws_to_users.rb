class AddWinsLossesDrawsToUsers < ActiveRecord::Migration
  def up
    add_column :users, :user_wins, :integer, default: 0
    add_column :users, :user_losses, :integer, default: 0
    add_column :users, :user_draws, :integer, default: 0
  end
  def down
    remove_column :users, :user_wins, :integer
    remove_column :users, :user_losses, :integer
    remove_column :users, :user_draws, :integer
  end
end
