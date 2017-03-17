#! /usr/bin/env ruby

# Check availability of web hostnames.

def checkhost(n, ext)
	fn = "#{n}.#{ext}"
	print "Checking '#{fn}' ..."
	$stdout.flush
	result = (`host #{fn} | grep 'has address'`)
	if result == ""
		puts " \tfree"
	else
		puts " \ttaken"
	end
end
