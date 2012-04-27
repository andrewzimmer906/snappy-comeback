class Gif < ActiveRecord::Base
  #Tire Includes (Search)
  include Tire::Model::Search
  include Tire::Model::Callbacks

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  
  has_many :taggings, :dependent => :destroy
  has_many :tags, :through => :taggings
  
  attr_accessor :tag_names
  after_save :assign_tags
    
  #Search Mapping
  def to_indexed_json
  	to_json(:only => :title, :include => :tags)
  end
    
    
  #Search Function
  def self.search(params)
    tire.search(load: true) do
      query { string params[:query], default_operator: "AND" } if params[:query].present?
	end	  
  end
  
  private
  
  def assign_tags
  	if @tag_names
  		self.tags = @tag_names.split(/, */).map do |name|
  			Tag.find_or_create_by_name(name)
  		end
  	end
  end
  
  def tag_names
  	@tag_names || tags.map(&:name).join(', ')
  end
end
