#!/usr/bin/perl -wl

package terra_mystica;

use vars qw(%map %reverse_map);
use strict;

our %map = ();
our %reverse_map = ();

my @map = qw(brown gray green blue yellow red brown black red green blue red black E
             yellow x x brown black x x yellow black x x yellow E
             x x black x gray x green x green x gray x x E
             green blue yellow x x red blue x red x red brown E
             black brown red blue black brown gray yellow x x green black blue E
             gray green x x yellow green x x x brown gray brown E
             x x x gray x red x green x yellow black blue yellow E
             yellow blue brown x x x blue black x gray brown gray E
             red black gray blue red green yellow brown gray x blue green red E);

sub setup_base_map {
    my $ri = 0;
    my $river = 0;
    for my $row ('A'..'I') {
        my $col = 1;
        for my $ci (0..13) {
            my $color = shift @map;
            last if $color eq 'E';
            if ($color ne 'x') {
                $map{"$row$col"}{color} = $color;
                $map{"$row$col"}{row} = $ri;
                $map{"$row$col"}{col} = $ci;
                $reverse_map{$ri}{$ci} = "$row$col";
                $col++;
            } else {
                my $key = "r$river";
                $map{"$key"}{color} = 'white';
                $map{"$key"}{row} = $ri;
                $map{"$key"}{col} = $ci;
                $reverse_map{$ri}{$ci} = "$key";
                $river++;
            }
        }
        $ri++;
    }
}

sub setup_direct_adjacencies {
    sub record_adjacent {
        my ($this, $other) = @_;
        if ($other) {
            $map{$this}{adjacent}{$other}++;
        }
    }

    for my $coord (keys %map) {
        my $row = $map{$coord}{row};
        my $col = $map{$coord}{col};

        # Same row
        record_adjacent $coord, $reverse_map{$row}{$col+1};
        record_adjacent $coord, $reverse_map{$row}{$col-1};

        # Adjacent rows. Need to offset the column by one for every other
        # row.
        if ($row % 2 == 0) {
            $col--;
        }

        record_adjacent $coord, $reverse_map{$row - 1}{$col};
        record_adjacent $coord, $reverse_map{$row - 1}{$col + 1};
        record_adjacent $coord, $reverse_map{$row + 1}{$col};
        record_adjacent $coord, $reverse_map{$row + 1}{$col + 1};
    }
}

sub setup_hex_ranges {
    my ($from, $river_only) = @_;
    my %aux = ();
    my $max = ($river_only ? 6 : 2);

    return if $from =~ /^r/;

    $aux{$from} = -1;
    for my $range (0..$max) {
        for my $hex (keys %aux) {
            next if $aux{$hex} != $range - 1;
            next if $river_only and $range != 0 and $hex !~ /^r/;
            for my $adj (keys %{$map{$hex}{adjacent}}) {
                if (!exists $aux{$adj}) { 
                    $aux{$adj} = $range;
                }
            }
        }
    }

    $map{$from}{range}{$river_only} = { %aux };
}

sub setup_ranges {
    setup_hex_ranges $_, 0 for keys %map;
    setup_hex_ranges $_, 1 for keys %map;
}

setup_base_map;
setup_direct_adjacencies;
setup_ranges;

1;