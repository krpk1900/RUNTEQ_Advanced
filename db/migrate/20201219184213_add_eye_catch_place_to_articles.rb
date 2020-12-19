class AddEyeCatchPlaceToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :eyecatch_place, :integer, default: 0
  end
end
