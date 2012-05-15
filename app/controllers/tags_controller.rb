class TagsController < ApplicationController
  # GET /tags
  # GET /tags.json
  def index
  	 @tags = Tag.order(:name) #Tag.search(params)
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
    @tag = Tag.find(params[:id])
    @gifs = @tag.getGifsPaginated(params);
  end
end