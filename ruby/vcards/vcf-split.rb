#!/usr/bin/env ruby

require 'pp'

all = []
current = ''
ARGF.read.each_line do |line|
  if line.strip == ''
    all << current
    current = ''
  else
    current << line
  end
end

all.each do |e|
  if matches = e.match(/^FN:(.*)$/)
    name = matches[1].strip.gsub(/ /, '.')
  else
    puts "SKIPPING: #{e}"
    next
  end
  File.open("#{name}.vcf", 'w') do |f|
    f.puts e
  end
end

