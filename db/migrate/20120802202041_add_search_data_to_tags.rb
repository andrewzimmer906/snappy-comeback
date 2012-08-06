class AddSearchDataToTags < ActiveRecord::Migration
  def change
    add_column :tags, :searchData, :string

  end
end
