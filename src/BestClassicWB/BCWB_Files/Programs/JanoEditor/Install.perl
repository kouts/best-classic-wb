#!/usr/bin/perl
# Perl script to generate catalog's installer script
# Written by T.Pierron 13 feb 2002
# Free software under GNU public license

$file    = "Catalogs/Install catalog";
$app     = "JanoEditor";
$version = "v1.01";
$dir     = "Catalogs";

if( $#ARGV == 0 )
{
	$dir = $ARGV[0];
}

# Remove ending slash
if( $dir =~ /\/$/ )
{
	chop $dir;
}

# Search for installed language
opendir DIR, "$dir" or die "$dir: $!";

while( $ent = readdir DIR )
{
	if( $ent =~ /\.ct$/ ) {
		push @Catalogs, substr($ent, 0, -3);
	}
}

closedir DIR;

if( $#Catalogs < 0 )
{
	die "No catalogs translation files in the directory $dir!";
}

open OUTFILE, ">$file" or die "$file: $!";

print OUTFILE "; Automatically generated - do not edit!\n\n";

print OUTFILE "(set APPNAME $app)\n\n";

print OUTFILE "(set M_WELCOME (cat \"Welcome to the installation of $app $version.\"))\n\n";

print OUTFILE "(set WHICH_CATALOG (cat \"\\nWhich language do you want to install ? (in LOCALE:)\\n\"))\n\n";

print OUTFILE "(set vernum (getversion \"locale.library\" (resident)))\n";
print OUTFILE "(set ver (shiftright vernum 16))\n\n;\n";
print OUTFILE "; Here is the screen where the user's skill is controlled\n";
print OUTFILE ";\n\n(welcome M_WELCOME)\n\n";

print OUTFILE "(if (>= ver 38)\n\t(\n";
print OUTFILE "\t\t(set DEF_LANG 0)\n";

# Try to set default language
$i = 1;
foreach $lang (@Catalogs) {

	print OUTFILE "\t\t(if (= \@language \"$lang\") (set DEF_LANG $i))\n";

	$i = $i << 1;
}

# Ask user to choose language to install
print OUTFILE "\t\t(set CATALOGS DEF_LANG)\n";
print OUTFILE "\t\t(set CATALOGS (askoptions (prompt WHICH_CATALOG)\n";
print OUTFILE "\t\t\t(help \@askoptions-help)\n";
print OUTFILE "\t\t\t(choices ";

foreach $lang (@Catalogs) {
	print OUTFILE "\"" . ucfirst($lang) . "\" ";
}
print OUTFILE ")\n\t\t\t(default DEF_LANG)\n";
print OUTFILE "\t\t))\n";

# Copy Catalogs file
$i = 1;
foreach $lang (@Catalogs) {

	print OUTFILE "\t\t(if (BITAND CATALOGS $i)\n";
	print OUTFILE "\t\t\t((copyfiles (prompt (cat MSG_COPYLANG \"$lang...\"))\n";
	print OUTFILE "\t\t\t           (help \@copyfiles-help)\n";
	print OUTFILE "\t\t\t           (source \"$lang/$app.catalog\")\n";
	print OUTFILE "\t\t\t           (dest   \"LOCALE:Catalogs/$lang\"))\n";
	print OUTFILE "\t\t\t(copyfiles (prompt (cat MSG_COPYLANG \"$lang...\"))\n";
	print OUTFILE "\t\t\t           (help \@copyfiles-help)\n";
	print OUTFILE "\t\t\t           (source \"$lang/JanoPrefs.catalog\")\n";
	print OUTFILE "\t\t\t           (dest   \"LOCALE:Catalogs/$lang\")\n";
	print OUTFILE "\t\t\t)\n\t\t))\n";

	$i = $i << 1;
}
print OUTFILE "\t)\n)\n";

close OUTFILE;

# Output script to automatically rebuild catalogs

open OUTFILE, ">Sources/makecat" or open OUTFILE, ">makecat" or die "makecat: $!";

print OUTFILE "; AmigaDOS script to rebuild " . $app . "'s catalog\n\n";

print OUTFILE "; Rebuild strings header:\n";
print OUTFILE "CatComp /$dir/$app.cd CFILE ${app}Strs.h\n\n";


foreach $lang (@Catalogs) {
	print OUTFILE "CatComp /$dir/$app.cd /$dir/$lang.ct CATALOG /$dir/$lang/$app.catalog\n";
}

close OUTFILE;


