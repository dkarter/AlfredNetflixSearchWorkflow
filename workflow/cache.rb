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
class Integer
  def to_filesize
    {
      'B'  => 1024,
      'KB' => 1024 * 1024,
      'MB' => 1024 * 1024 * 1024,
      'GB' => 1024 * 1024 * 1024 * 1024,
      'TB' => 1024 * 1024 * 1024 * 1024 * 1024
    }.each_pair { |e, s| return "#{(self.to_f / (s / 1024)).round(2)}#{e}" if self < s }
  end
end

($LOAD_PATH << File.expand_path('..', __FILE__)).uniq!
cache_path = "#{Dir.pwd}/tmp/*.jpg"

if ARGV[0] == 'menu'
  size = Dir.glob(cache_path).map { |f| File.size(f) }.reduce(:+)
  output = []
  output << '<items>'
  output << '  <item arg="clean" uid="0" valid="yes">'
  output << '    <title>Yes</title>'
  output << "    <subtitle>I am sure I want to remove #{size.to_filesize}</subtitle>"
  output << '    <icon>icon.png</icon>'
  output << '  </item>'
  output << '  <item arg="" uid="0" valid="yes">'
  output << '    <title>No</title>'
  output << '    <subtitle>I\'m having second thoughts</subtitle>'
  output << '    <icon>icon.png</icon>'
  output << '  </item>'
  output << '</items>'

  puts output.join('\n')
end

Dir.glob(cache_path).each { |f| File.delete(f) } if ARGV[0] == 'clean'
