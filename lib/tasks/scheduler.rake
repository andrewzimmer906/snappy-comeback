require 'rubygems'
require 'simple-rss'
require 'open-uri'
require 'cgi'

desc "This task is called by the Heroku scheduler add-on"

task :get_gifs_from_reddit => :environment do
    puts "Getting Gifs..."
	
	rss = SimpleRSS.parse open('http://www.reddit.com/r/reactiongifs.rss')
   	rss.items.each do |item|
    	regResponse = item.description.match(/&lt;a href=&#34;(http:\/\/i?.?(minus|imgur).com\/.+)&#34;&gt;\[link\]/i)
    	if(regResponse != nil)
    		link = regResponse[1]
    		title = CGI::unescape(item.title)
   			title = title.gsub("&quot;", "\"");
    		
    		gifsWithName = Gif.find(:all, :conditions => {:title => title })
    		
    		if gifsWithName.empty?
    			gif = Gif.new(:title => title)
    			gif.image_from_url(link)
    			gif.save
    			puts "Added Item: " + title + " : " + link
    		else
    			puts "Skipping " + title + " (duplicate)"
    		end
    	else
    		puts "Error URL: " + item.title + '\n'
    	end
    end
    puts "done."
end