class AddDefaultValueToCapturedAttribute < ActiveRecord::Migration
  def up
    change_column  :pieces, :captured, :boolean, default: false
  end

  def down
    change_column  :pieces, :captured, :boolean, default: nil
  end
end
