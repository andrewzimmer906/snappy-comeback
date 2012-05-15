class AddCountToTags < ActiveRecord::Migration
  def change
    add_column :tags, :count, :integer

  end
end
