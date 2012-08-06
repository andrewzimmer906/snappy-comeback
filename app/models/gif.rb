require 'open-uri'
require 'will_paginate'

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
    indexes :created_at, type: 'date'
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
	  if(params[:query].present?)
	  	tire.search(load: true, page: params[:page], per_page: 5) do
	  	 	query { string params[:query], default_operator: "AND" } if params[:query].present?
	  	end
	  else
	  	Gif.paginate(:page => params[:page], :per_page => 5).order('created_at DESC')
	  end
  end
  
  def image_from_url(url)
  	self.image = open(url)
  end
  
  def Gif.empty_gifs_with_paging(params)
  	Gif.paginate(:page => params[:page], :per_page => 5, :conditions => {:tag_names => nil||'' }).order('created_at DESC')
  		
	  #Gif.find(:all, :conditions => {:tag_names => nil||'' }).paginate(:page => params[:page], :per_page => 5).order('created_at DESC')
  end
  
  def Gif.confusedGif
  	tire.search(load: true, page: 1, per_page: 1) do
  	 	query { string "Confused", default_operator: "AND" }
  	end
  end
  
  private
  
  def assign_tags
	  self.tag_names = tags.map(&:searchString).join(' ')
  end
end
