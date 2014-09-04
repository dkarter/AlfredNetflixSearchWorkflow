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

netflix_api = 'http://netflix.atr.io'

results = JSON.load(open(URI.encode("#{netflix_api}/autocomplete/#{ARGV[1]}")))

search_type = ARGV[0]
title_key = search_type == 'titles' ? 'title' : 'name'
group = results['groups'].select { | g | g['type'] == search_type }

output = []
output << '<items>'

unless results['groups'] == [] || group.length == 0
  items = group[0]['items'] || []
  items.each do |item|

    item['title'] = "#{item['title']} #{item['disambiguation']}" if item.key? 'disambiguation'

    output << "  <item arg='#{item['id']}' uid='#{item['id']}' valid='yes'>"
    output << "    <title>#{item[title_key]}</title>"
    output << '    <subtitle>Press enter to open on Netflix</subtitle>'
    output << '    <icon>icon.png</icon>'
    output << '  </item>'

  end
end

output << '</items>'

puts output.join("\n")