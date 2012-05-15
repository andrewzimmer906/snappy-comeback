class Tag < ActiveRecord::Base
	include Tire::Model::Search
	include Tire::Model::Callbacks
	
	if Rails.env != "development"
			index_name BONSAI_INDEX_NAME
	end
	
	before_save :calculateCount
	
	has_many :taggings, :dependent => :destroy
	has_many :gifs, :through => :taggings
	
	#Get Most Popular Tags
	def Tag.get_popular_tags
		Tag.limit(4).find(:all, :order => 'count DESC')
	end
	
	#Get Gifs
	def getGifsPaginated(params)
		self.gifs.paginate(:page => params[:page], :per_page => 5).order('created_at DESC')
	end
	
	#Search Function
	def self.search(params)
	  tire.search(load: true) do
	    query { string params[:query], default_operator: "AND" } if params[:query].present?
	  end
	end	  
	
	def calculateCount 
		self.count = self.gifs.count
	end
end
