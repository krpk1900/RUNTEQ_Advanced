class AddEyeCatchWidthToArtilcles < ActiveRecord::Migration[5.2]
  def up
    add_column :articles, :eye_catch_width, :integer
  end

  def down
    remove_column :articles, :eye_catch_width, :integer
  end
end
