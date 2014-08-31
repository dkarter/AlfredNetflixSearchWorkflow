#!/usr/bin/env ruby
# encoding: utf-8

require 'rubygems' unless defined? Gem # rubygems is only needed in 1.8
require "bundle/bundler/setup"
require "alfred"
require 'json'
require 'open-uri'



Alfred.with_friendly_error do |alfred|
  fb = alfred.feedback

  
  results = JSON.load(open(URI::encode('http://localhost:8080/autocomplete/' + ARGV[0])))
  resultsJson = JSON.parse(results)

  titles = resultsJson['groups'].select { | g | g['type'] == 'titles' }

  if resultsJson['groups'] == [] || titles.length == 0
    puts "Cannot find titles"
  else
    movies = titles[0]['items'] || 'nothing found'
    movies.each do |movie|
      movie['title'] = "#{movie['title']} #{movie['disambiguation']}" if movie.has_key? 'disambiguation'
      fb.add_item({
        uid:      "#{movie['id']}",
        title:    "#{movie['title']}",
        subtitle: "http://www.netflix.com/WiPlayer?movieid=#{movie['id']}",
        arg:      "" ,
        valid:    "yes",
      })
      
    end
  end

  
      
  
  
  # # add an feedback to test rescue feedback
  # fb.add_item({
  #   :uid          => ""                     ,
  #   :title        => "Rescue Feedback Test" ,
  #   :subtitle     => "rescue feedback item" ,
  #   :arg          => ""                     ,
  #   :autocomplete => "failed"               ,
  #   :valid        => "no"                   ,
  # })

  if ARGV[0].eql? "failed"
    alfred.with_rescue_feedback = true
    raise Alfred::NoBundleIDError, "Wrong Bundle ID Test!"
  end

  puts fb.to_xml(ARGV)
end



