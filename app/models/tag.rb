class Tag < ActiveRecord::Base
	include Tire::Model::Search
	include Tire::Model::Callbacks
	
	if Rails.env != "development"
			index_name BONSAI_INDEX_NAME
	end

	has_many :taggings, :dependent => :destroy
	has_many :gifs, :through => :taggings
	
	#Search Function
	def self.search(params)
	  tire.search(load: true) do
	    query { string params[:query], default_operator: "OR" } if params[:query].present?
	  end
	end	  
end
