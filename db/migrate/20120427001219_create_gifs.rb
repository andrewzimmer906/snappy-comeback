class CreateGifs < ActiveRecord::Migration
  def change
    create_table :gifs do |t|
      t.string :title

      t.timestamps
    end
  end
end
