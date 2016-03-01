#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

=head1

extract_hex_from_xresources.cpp

Usage ./extract_hex_from_xresources.pl [xresources file]

Extracts the hex codes from the .Xresources one per line and always in the same order

=cut


sub HELP {
	print "Usage $0 \t [xresources file]\n"
	."Extracts the hex codes from the .Xresources one per line and always in the same order.\n"
	."Use -s as a file for stdin\n";
	exit;
}

=head2
here's what the colors are
! ! --- special colors ---
*background: #222222
*foreground: #e6e3c6
! --- standard colors ---
! black
*color0: #151515
! red
*color1: #ff6666
! green
*color2: #7a8c5c
! yellow
*color3: #cc9933
! blue
*color4: #3a8679
! magenta
*color5: #d7773b
! cyan
*color6: #339966
! white
*color7: #d4c894
! bright_black
*color8: #3e3c3a
! bright_red
*color9: #ff6c6c
! bright_green
*color10: #7f9062
! bright_yellow
*color11: #ce9c3a
! bright_blue
*color12: #428b7e
! bright_magenta
*color13: #d97d44
! bright_cyan
*color14: #3b9d6c
! bright_white
*color15: #d6ca98

Changes are gonna be:

old was #27b062 green-like (meta) -> color2
old was #5b92fa - blue-like (discussion) -> color4
old was #9b59b6 - purple-like (material) -> color5
old was #34495e - cyan-like (material)  -> color6
old was #e74c3c - red-like (workflow)  -> color1
old was #f1c40f - yellow-like (screenshot) -> color3
old was #95a5a6 - grey-like (All) -> color0
black-like #191414 -> background
box shadow #212121 -> color0
border color #707070 -> color8
foreground - white-like (custom theme) #e6e3c6  -> foreground
=cut

my @COLORS;
my %COLORS_INDEXES = (
	background => 0,
	foreground => 1,
	color0 => 2,
	color1 => 3,
	color2 => 4,
	color3 => 5,
	color4 => 6,
	color5 => 7,
	color6 => 8,
	color7 => 9,
	color8 => 10,
	color9 => 11,
	color10 => 12,
	color11 => 13,
	color12 => 14,
	color13 => 15,
	color14 => 16,
	color15 => 17
);


sub extract_hex {
	my ($source) = @_;
	my $fh;
	if ($source eq '-s') {
		$fh = \*stdin;
	}
	else {
		open($fh, "<", $source) or die "$!";
	}
	while (<$fh>) {
		for my $i (keys %COLORS_INDEXES) {
			if (/$i\s*:/) {
				chomp;
				$_ =~ /#([\da-f]{6})/i;
				$COLORS[$COLORS_INDEXES{$i}] = lc($1);
			}
		}
	}
	return @COLORS;
}


sub main {
	my $resource_file = shift @ARGV;
	HELP if (!$resource_file);
	my @cols = extract_hex($resource_file);
	#print "$_\n" for (@cols);
	my $fh;
	open($fh, "<", 'reddit.css') or die "$!";
	my $out = '';
	while (<$fh>) { 
		if (/27b062/) { #old was 27b062 green-like (meta) -> color2
			$_ =~ s/27b062/$cols[4]/;
		}
		if (/5b92fa/) { #old was 5b92fa - blue-like (discussion) -> color4
			$_ =~ s/5b92fa/$cols[6]/;
		}
		if (/9b59b6/) { #old was 9b59b6 - purple-like (material) -> color5
			$_ =~ s/9b59b6/$cols[7]/;
		}
		if (/34495e/) { #old was 34495e - cyan-like (material)  -> color6
			$_ =~ s/34495e/$cols[8]/;
		}
		if (/e74c3c/) { #old was e74c3c - red-like (workflow)  -> color1
			$_ =~ s/e74c3c/$cols[3]/;
		}
		if (/f1c40f/) { #old was f1c40f - yellow-like (screenshot) -> color3
			$_ =~ s/f1c40f/$cols[5]/;
		}
		if (/95a5a6/) { #old was 95a5a6 - grey-like (All) -> color0
			$_ =~ s/95a5a6/$cols[2]/;
		}
		if (/191414/) { #black-like 191414 -> background
			$_ =~ s/191414/$cols[0]/;
		}
		if (/212121/) { #box shadow 212121 -> color0
			$_ =~ s/212121/$cols[2]/;
		}
		if (/707070/) { #border color 707070 -> color8
			$_ =~ s/707070/$cols[10]/;
		}
		if (/e6e3c6/) { #foreground - white-like (custom theme) e6e3c6  -> foreground
			$_ =~ s/e6e3c6/$cols[1]/;
		}
		$out .= $_;
	}
	print $out;

}


main;
