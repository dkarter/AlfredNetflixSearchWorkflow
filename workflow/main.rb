#!/usr/bin/env ruby
# encoding: utf-8

# ===================================================
# Netflix Alfred Workflow
# Developed by: Dorian Karter
# Website: https://github.com/dkarter/AlfredNetflixSearchWorkflow
# Netflix API (unofficial): https://github.com/dkarter/NetflixScraperAPI
# License: MIT
# Disclaimer: I am not connected and or affiliated with Netflix,
# this code was written purely for educational purposes and with
# no other intent, warranty or purpose. Use at your own risk and responsiblity.
# ===================================================

($LOAD_PATH << File.expand_path('..', __FILE__)).uniq!
require 'rubygems' unless defined? Gem # rubygems is only needed in 1.8

require 'json'
require 'open-uri'

def save_icon(url, name)
  filename = File.expand_path("#{Dir.pwd}/tmp/#{name}.jpg", __FILE__)
  unless File.exist?(filename)
    File.open(filename, 'wb') do |fo|
      fo.write open(url).read
    end
  end
  filename
end

netflix_api = 'http://netflix.atr.io'
url = "#{netflix_api}/autocomplete/?query=#{ARGV[1]}&country=#{ARGV[2]}"
results = JSON.load(open(URI.encode(url)))

search_type = ARGV[0]
title_search = search_type == 'titles'
title_key = title_search ? 'title' : 'safename'

group = results[title_search ? 'galleryVideos' : 'railPeople']

output = []
output << '<items>'

if group && group.length > 0
  items = group['items'] || []
  items.each do |item|
    item['icon'] = (item.key? ('boxart')) ? save_icon(item['boxart'], item['id']) : 'icon.png'
    item['title'] = "#{item['title']} #{item['disambiguation']}" if item.key? 'disambiguation'

    output << "  <item arg='#{item['id']}' uid='#{item['id']}' valid='yes'>"
    output << "    <title><![CDATA[#{item[title_key]}]]></title>"
    output << '    <subtitle>Press enter to open on Netflix</subtitle>'
    output << "    <icon>#{item['icon']}</icon>"
    output << '  </item>'

  end
end

output << '</items>'

puts output.join("\n")
