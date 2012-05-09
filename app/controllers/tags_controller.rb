class TagsController < ApplicationController
  # GET /tags
  # GET /tags.json
  def index
  	 @tags = Tag.all #Tag.search(params)
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
    @tag = Tag.find(params[:id])
    @gifs = @tag.gifs;
  end
  
	def destroy
	  @tag = Tag.find(params[:id])
	  @tag.destroy
	
	  respond_to do |format|
	    format.html { redirect_to tags_url }
	    format.json { head :no_content }
	  end
	end
	    
	# GET /gifs/new
	# GET /gifs/new.json
	def new
		@tag = Tag.new
	end
	
	def create
		@tag = Tag.new(params[:tag])
		
		respond_to do |format|
			if @tag.save
				format.html { redirect_to tags_url, notice: 'Tag was successfully created.' }
				format.json { render json: @tag, status: :created, location: @tag }
			else
				format.html { render action: "new" }
				format.json { render json: @tag.errors, status: :unprocessable_entity }
			end
		end
	end
end

	
