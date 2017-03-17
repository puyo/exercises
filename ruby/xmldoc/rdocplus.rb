#!/usr/bin/env ruby

require 'rdocplus/rdocplus'

if $0 == __FILE__
  if ARGV.empty?
    puts "Usage: #{File.basename($0)} file"
    exit
  end
  infile = ARGV[0]
  outdir = 'html'
  documentation = RDocPlus::Documentation.new(infile, outdir, :verbose => ARGV.index('-v') != nil)
  documentation.output
end
