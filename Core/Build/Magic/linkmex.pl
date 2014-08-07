# '--*-Perl-*--';
# linkmex.pl
#
# perl script to link mex file dll / engine file exe
#
# create library files
# create temporary files for dll creation
# create dll 
# delete temporary files

# dlltool command
$dllcmd = 'dlltool';


#---
# grab environment vars
#---

$mlpath = "\"$ENV{'MATLAB'}\"";

$mrmexpath = "$ENV{'MRMEXPATH'}\\";

@libs = ($ENV{'DEFS2LINK'} =~ /([\w\.]+);/g);


# linker definition file
$mexdef = "\"${mrmexpath}mex.def\"";

#---
# create import libraries
#---

# based on gnumex

$libname = 'mexlib';

$libno = 1;
foreach $lib(@libs) {
	$cmd = "$dllcmd --def $mlpath\\extern\\include\\$lib --output-lib \"${mrmexpath}${libname}${libno}.a\"";
    if (! -e "${mrmexpath}${libname}${libno}.a") {
        print "creating import library $libno...\n";
        $message = `$cmd`;
    } else{
        $message = "";
    }
        
	print $message unless ($message eq "");
	$libno += 1;
}

for $libno(1..$#libs+1) {
    $libnames[$libno] = "\"${mrmexpath}${libname}${libno}.a\"";
}

#---
# link in the malloc-type wrappers
#---

#$wrapflag = 0;
#$wrapobj = "";

$argix = 1;

@args;

foreach $arg(@ARGV){	

	@args[$argix] = $arg;		

	$argix += 1;
}

$arglist = join(" ", @args);

$wrapobj = "\"${mrmexpath}mwraps.o\"";

$wrapsrc = "\"${mrmexpath}mwraps.c\"";

$compilecmd = "gcc -c -o $wrapobj $wrapsrc";

if (! -e "${mrmexpath}mwraps.o"){

	print "compiling memory allocation wrapper functions. \n";

	print "\n--> \"$compilecmd\" \n";

	$message = `$compilecmd`;

}

#--- 
# generate command to make mex dll
#---

$linker = 'gcc -shared';

$lnklibs = $ENV{LINK_LIB};

$cmd = join(" ", $linker, $mexdef, $arglist, $wrapobj, $lnklibs, @libnames);
  
print "\n--> \"${cmd}\" \n";

#---  
# run the command and collect the output
#---

$message = `$cmd`;

