#!/usr/bin/perl
use strict;
use warnings;
use POSIX;

#log in base 2
sub log2 {
	my $n = shift;
	return log($n)/log(2);
}

#calculating number of layers with given formula
sub get_num_layers{
	my $n = shift;
	return ceil(7/log2($n));
}


#converting number from base 10 to wanted base by taking modulus as next digit
sub convert_to_base{
	my $num = shift;
	my $base = shift;
	my $digit = 0;
	my @converted = ();
	
	while ($num > 0){
		$digit = $num % $base;
		unshift(@converted, $digit);
		$num = floor($num / $base);
	}
	
	#adding zeros if number has too few digits
	my $size_converted = @converted; 
	while ($size_converted < $base){
		unshift (@converted, 0);
		$size_converted = $size_converted + 1;
	}
	
	
	return @converted;
}

my $name = 'C:\Users\Nikola\Desktop\proba.txt'; #chomp($ARGV[0]);                      #file specified in argument
open (my $file, '<', $name) or die $!;    	#open file with given filename
my $num_layers = 4;


#reading the characters from the given file (spliting the file to the array of characters)
my @characters = [];
while(<$file>) {
						#$_ = lc($_); # convert everything to lowercase  
    @characters = split (//, $_);  
}

my @root = ();
my %hash_table=();

#converting characters and putting them into the tree
foreach my $char (@characters){
	
	my $char_ord = ord($char);
	my @converted_chars = convert_to_base($char_ord, $num_layers);
	
	unless (exists $hash_table{'root'}){
		$hash_table{'root'} = [];
	}
	push ($hash_table{'root'}, $converted_chars[0]);
	
	my $string = "" . $converted_chars[0];
	
	for (my $i=1; $i < $num_layers; $i++) {
		#print $string; print " ";
		unless (exists $hash_table{$string}){
			$hash_table{$string} = [];
		}
		push ($hash_table{$string}, $converted_chars[$i]);
		
		$string = $string . $converted_chars[$i];
		
		#print $converted_chars[$i]; print " ";
	} 
}

#print "@characters";                     #testing - reading file
#my $proba = get_num_layers(5);           #testing - get_num_layers
#my @proba = convert_to_base(67, 4, 5);   #testing - convert_to_base
#print "@proba";

#print <$file>;                           #testing - reading the file

close($file);                             #close the input file


