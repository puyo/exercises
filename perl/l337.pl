#! /usr/bin/perl -w

# l337.pl, written by Greg McIntyre, 2001
# May have been edited beyond recognition since then.

# Remember... a single '\' must be written here as '\\', because it is an escape code.

$l337{'A'} = '4';
$l337{'B'} = '|3';
$l337{'C'} = 'C';
$l337{'D'} = 'D';
$l337{'E'} = '3';
$l337{'F'} = '|=';
$l337{'G'} = 'G';
$l337{'H'} = '|-|';
$l337{'I'} = '1';
$l337{'J'} = 'J';
$l337{'K'} = '|<';
$l337{'L'} = '/_';
$l337{'M'} = '/\\\\';
$l337{'N'} = '|\\|';
$l337{'O'} = '0';
$l337{'P'} = 'P';
$l337{'Q'} = 'Q';
$l337{'R'} = 'R';
$l337{'S'} = '5';
$l337{'T'} = '7';
$l337{'U'} = '(_)';
$l337{'V'} = '\\/';
$l337{'W'} = '\\\\/';
$l337{'X'} = '><';
$l337{'Y'} = 'Y';
$l337{'Z'} = '2';


# If not enough arguments, print usage and exit.

if (@ARGV >= 1) {
	print("Usage: perl l337.pl\n");
	exit;
}

print("\nPress CTRL+C to quit.\n\n");

while (<>) {
	# l337 |7
	foreach $letter (keys %l337) {
		s/$letter/$l337{$letter}/gi;
    }
	print("\n$_\n---\n\n");
}
