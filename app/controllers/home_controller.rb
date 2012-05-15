class HomeController < ApplicationController
  def index
  	@tags = Tag.get_popular_tags
  	@hideHeader = true
  end
end
