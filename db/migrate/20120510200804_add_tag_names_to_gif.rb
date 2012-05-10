class AddTagNamesToGif < ActiveRecord::Migration
  def change
    add_column :gifs, :tag_names, :string

  end
end
