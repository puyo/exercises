#!/usr/local/bin/ruby

require "tk"

canvas = TkCanvas.new

grp = TkcGroup.new(canvas)
grp.add(TkcRectangle.new(canvas, '1c', '2c', '3c', '3c', 'outline' => 'black', 'fill' => 'blue'))

canvas.pack
canvas.bind 'Enter' do
	print "Entering!\n"
	grp.configure 'fill', 'red'
end

canvas.bind 'Leave' do
	print "Leaving!\n"
	grp.configure 'fill', 'green'
end

Tk.mainloop
