require "open-uri"
require "json"

somefile = File.open("data.txt", "w")
parsedJSON = JSON.parse open('http://a.4cdn.org/a/catalog.json').read

sakiThreads = [];
parsedJSON.each do |obj|
	obj["threads"].each do |thread|
		threadInfo = ["", ""]
		threadInfo = [thread["no"].to_s , thread["sub"].to_s.downcase] if thread["sub"].to_s != ""
		if (threadInfo[1].match(/saki/) && threadInfo[1].match(/tanoshii/))
			sakiThreads.push(threadInfo)
		end
	end
end 

sakiThreads.each do |thread|
	uri = URI.parse('http://a.4cdn.org/a/res/' + thread[0].to_s + '.json')
	http = Net::HTTP.new(uri.host, uri.port)
	request = Net::HTTP::Get.new(uri.request_uri)
	response = http.request(request)
	parsedJSON = JSON.parse(response.body)
	
	parsedJSON["posts"].each {|x| somefile.puts(x["com"])}
end
somefile.close
