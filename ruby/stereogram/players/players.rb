#!/usr/bin/env ruby

$LOAD_PATH << ".."
require 'stereogram'

players = "blitz hazel kevin caleb dimi".split

players.each do |player|
	text = File.read("#{player}.txt").strip
	text.gsub!(/[^\w\s]/, '')
	text.gsub!(/[\s]/, '')
	text.downcase!
	image = File.read("#{player}.img")
	next if text.strip == "" or image.strip == ""
	puts player
	s = Stereogram.new(image, text, 20, 10, 10)
	File.open("#{player}.sgm", "w") do |file|
		s.output(file)
	end
end
