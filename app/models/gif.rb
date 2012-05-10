

class Gif < ActiveRecord::Base
  #Tire Includes (Search)
  include Tire::Model::Search
  include Tire::Model::Callbacks
  
  if Rails.env != "development"
    index_name BONSAI_INDEX_NAME
  end
  
  mapping do
    indexes :title, boost: 10
    indexes :tag_names
  end
  
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" },
  :storage => :s3,
  :s3_credentials => "#{Rails.root}/config/s3.yml",
  :path => "/:style/:id/:filename"
  
  has_many :taggings, :dependent => :destroy
  has_many :tags, :through => :taggings
  
  before_save :assign_tags
  before_update :assign_tags
 
 HUMANIZED_ATTRIBUTES = {
     :tag_names => "Tags",
     :title => "Title",
     :image => "Image"
   }
   
  validates_presence_of :title
  validates_attachment_presence :image
  #validates_length_of :tag_names, :minimum => 1, message: "You need to choose at least one tag"
  #￼validates :title, :presence => true
  #validates :tags, :length => { :minimum => 1 }
  #vaidates :image, :presence => true
  
  #Search Mapping
  #def to_indexed_json
  #	to_json(:only => :title, :include => :tags)
  #end
    
  #Search Function
  def self.search(params)
	  tire.search(load: true) do
	    query { string params[:query], default_operator: "AND" } if params[:query].present?
	  end	
  
  	#if params[:query].present?
  #		curGifs = Array.new
  #		
  # 		curTags = Tag.search(params) 		
  #		curTags.each do |tag|
  #			curGifs |= tag.gifs
  #		end
  #		curGifs
  #	else
  #		Gif.all
  #	end
      
  end
  
  private
  
  def self.privateSearch(params)
  	tire.search(load: true) do
  	  query { string params[:query], default_operator: "AND" } if params[:query].present?
  	end	
  end
  
  def assign_tags
	  self.tag_names = tags.map(&:name).join(' ')
  end
  
#  def tag_names
 # 	@tag_names || tags.map(&:name).join(', ')
 # end
end
