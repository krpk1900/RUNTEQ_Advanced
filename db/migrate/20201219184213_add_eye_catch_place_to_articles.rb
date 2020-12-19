class AddEyeCatchPlaceToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :eye_catch_place, :integer, default: 0
  end
end
