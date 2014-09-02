#test
require 'rubygems' unless defined? Gem
# require_relative 'bundle/bundler/setup'
require 'alfred'

require 'json'
require 'open-uri'

require 'json'
require 'open-uri'

results = JSON.load(open(URI::encode('http://netflix.atr.io/autocomplete/' + ARGV[0])))
# resultsJson = JSON.parse(results)

titles = results['groups'].select { | g | g['type'] == 'titles' }

if results['groups'] == [] || titles.length == 0
	puts "Cannot find titles"
else
	movies = titles[0]['items'] || 'nothing found'
	movies.each do |movie|
		movie['title'] = "#{movie['title']} #{movie['disambiguation']}" if movie.has_key? 'disambiguation'
		puts "#{movie['title']}, #{movie['id']}"
		# puts "#{movie['disambiguation']}" if movie.has_key? 'disambiguation'
	end
end