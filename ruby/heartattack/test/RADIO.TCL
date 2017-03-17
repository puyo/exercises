proc print { } {
	global print_pages
	puts "Print $print_pages."
}

label .l1 -text "Print Options"
frame .f1 -relief ridge -borderwidth 3
radiobutton .f1.r1 -text "All" -variable print_pages -value all -anchor w
radiobutton .f1.r2 -text "Current Page" -variable print_pages -value "Current Page" -anchor w

button .print -text "Print" -command { print }

pack .f1.r1 .f1.r2 -fill x -expand 1
pack .l1 .f1 .print

.f1.r2 invoke
