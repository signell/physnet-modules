# 10/27/98, pss

require ('/wp/file2arr.pls'); # file_to_array
require ('/wp/arr2file.pls'); # file_to_array
require ('/wp/sortf.pls')   ; # sortf(3,1,@lines)

# set the module number
$n = '0';

# die if the data file is not found
if (! -e 'm-'.$n.'-0.dat')
   {die("\n\n\n".'Error: file "m-'.$n.'-0.dat" not found in this directory.'."\n\n\n")}
   
# convert the data file to an array
@nlines = file_to_array('m-'.$n.'-0.dat');
# remove the trailing line-ends
grep {s/\n//s} @nlines;

# process the number-ordered list
\string_to_file('\chead{\textbf{M0DULES INDEX - n}}', 'm-0-0.chd');
process(@nlines);

# process the alpha-ordered list
\string_to_file('\chead{\textbf{M0DULES INDEX - a}}', 'm-0-0.chd');
# sort the alpha lines by column 5 and the next 49 columns
@alines = sortf(5,50,@nlines);
# discard unused numbers from the alpha list
@alines = grep !/^\D*\d+\s*$/,@alines;
process(@alines);

exit;

sub process {
 local @lines = @_;
 # convert to LaTeX tabbing
 grep {s/^\s*(\d+)\s*(.*?)$/\\> $1 \\\' $2 \\\\/} @lines;
 # save file to disk so LaTeX can read it in
 array_to_file(@lines,'m-'.$n.'-0.sor');
 # LaTeX the file
 system 'latex m-0-0-tx';
 # print the dvi file
 #system 'dvipr m-0-0-tx f';
 system 'dvipr m-0-0-tx s';
}   
exit;

