/* $VER: ProcessFile.rexx 0.23 (03.01.00) 
 * process a file according to the extension */
/* Authors Osma Ahvenlampi, Michael Van Elst, Dan Murrell Jr. 
 * Modified by Eric Sauvageau
 * View a file after de-archiving enhancement by Alejandro Garza */
/* Modified by Stephan Rupprecht for html documents
 * launches browser via OpenURL(.library) */

/* This is the program used to view the file if no match is found */
file.default = "SYS:Utilities/MultiView"

/* If this is set to 1, the user will be asked whether he wants to delete
 * the file after it has been processed */
file.delete = 0

/* If this is set to 1, the user will be prompted if he/she wants to view
 * any of the files in the archive after unpacking */
file.arcview = 1

/* list of supported archivers */
file.archive = "LHA LZH LZX"

/* where you would like the archive unpacked by default */
file.unpackdir = "ram:"

/* full paths to known (un)packers */
archiver.lha = "c:LhA"
archiver.lzx = "c:Lzx"

file.html = "HTM HTML"

/* next is the list of extensions and the programs used to show them
 * list the extensions in upper case */
file.1.type = "ILBM HAM GIF JPG JPEG"
file.1.viewer = "Multiview >NIL:"
file.2.type = "WAV AU 8SVX"
file.2.viewer = "Play16 >NIL:" /* LOTS better than OPlay... */
file.3.type = "GUIDE TXT DOC"
file.3.viewer = "SYS:Utilities/MultiView >NIL:"
file.4.type = "MPG MPEG"
file.4.viewer = "mp -dither gray8"
file.4.type = "MOV"
file.4.viewer = "qt HAM8 every=1"

/* this is the number of the last type */
file.num = 5

/* get filename */
parse arg '"' completename '"' '"' pubscreen '"'

if completename="" then
	parse arg completename

if ~exists(completename) then exit

if pubscreen="" then
	pubscreen = "Workbench"

viewed = 0
processed = 0

if ~show(l, 'rexxsupport.library') then do
	if ~addlib('rexxsupport.library', 0, -30) then do
		address command 'C:RequestChoice PUBSCREEN="'pubscreen'" TITLE="Process File Error" BODY="Could not execute macro*nlibs:rexxsupport.library not found" GADGETS="OK" >NIL:'
		exit 10
	end
end

call CheckExt

/* test it against known archivers/packers */
if (extension ~= "") & (find( file.archive, extension ) > 0) then do
	viewed = 1
	call UnPack
end

if (extension ~= "") & (find( file.html, extension ) > 0) then do
	viewed = 1
	call OpenURL
end

/* test it against known file types */
if ~viewed & (extension ~= "") then
	do i = 1 to file.num while ~viewed
		if find( file.i.type, extension ) > 0 then do
			viewed = 1
			address command file.i.viewer '"'completename'"'
			if rc = 0 then
				processed = 1

                end
	end

exit

UnPack:
	if (extension = "LHA") | (extension = "LZH") then do
		address command 'C:RequestChoice PUBSCREEN="'pubscreen'" TITLE="Process File" BODY="View archive?" GADGETS="Yes|No" >T:reqchoice.arcview'

		call open(choicefile, 'T:reqchoice.arcview', 'R')
		answer = readln(choicefile)
		call close(choicefile)
		address command 'C:Delete >NIL: T:reqchoice.arcview'

		if answer = '1' then do

        		address command 'LhA  v "'completename'" '

                end
		address command 'C:RequestChoice PUBSCREEN="'pubscreen'" TITLE="Process File" BODY="Un-LHA file 'completename'?" GADGETS="Yes|No" >T:reqchoice.unlha'
	
		call open(choicefile, 'T:reqchoice.unlha', 'R')
		answer = readch(choicefile, 1)
		call close(choicefile)
		address command 'C:Delete >NIL: T:reqchoice.unlha'

		if answer = '1' then do
			address command 'C:RequestFile SAVEMODE DRAWER="'file.unpackdir'" TITLE="Choose destination directory" NOICONS DRAWERSONLY PUBSCREEN="'pubscreen'" >T:req.drawer'

			call open(choicefile, 'T:req.drawer', 'R')
			file.unpackdir = readln(choicefile)
			call close(choicefile)
			address command 'C:Delete >NIL: T:req.drawer'
	
			if length(answer) > 0 then do
				address command archiver.lha 'x "'completename'" 'file.unpackdir
				processed = 1
			end
		end

                return

	end


	if (extension = "LZX") then do
		address command 'C:RequestChoice PUBSCREEN="'pubscreen'" TITLE="Process File" BODY="View archive?" GADGETS="Yes|No" >T:reqchoice.arcview'

		call open(choicefile, 'T:reqchoice.arcview', 'R')
		answer = readln(choicefile)
		call close(choicefile)
		address command 'C:Delete >NIL: T:reqchoice.arcview'

		if answer = '1' then do

        		address command 'Lzx v "'completename'" >T:LhaContents.tmp'
	        	address command file.default 'T:LhaContents.tmp'
		        address command 'C:Delete >NIL: T:LhaContents.tmp'
                end
		address command 'C:RequestChoice PUBSCREEN="'pubscreen'" TITLE="Process File" BODY="Un-LZXfile 'completename'?" GADGETS="Yes|No" >T:reqchoice.unlha'
	
		call open(choicefile, 'T:reqchoice.unlha', 'R')
		answer = readch(choicefile, 1)
		call close(choicefile)
		address command 'C:Delete >NIL: T:reqchoice.unlha'

		if answer = '1' then do
			address command 'C:RequestFile SAVEMODE DRAWER="'file.unpackdir'" TITLE="Choose destination directory" NOICONS DRAWERSONLY PUBSCREEN="'pubscreen'" >T:req.drawer'

			call open(choicefile, 'T:req.drawer', 'R')
			file.unpackdir = readln(choicefile)
			call close(choicefile)
			address command 'C:Delete >NIL: T:req.drawer'
	
			if length(answer) > 0 then do
				address command archiver.lzx 'x "'completename'" 'file.unpackdir
				processed = 1
			end
		end
	end

	
	return

CheckExt:
	/* find position of the last period, if any, to set off the file extension */
	dot = lastpos(".", completename)

	if (dot > 0) then do
		/* there is an extension.. put it in another variable and make it upper case */
		filename = left(completename, dot-1)
		extension = upper(substr(completename, dot+1))
	end
	else do
		filename = completename
		extension = ""
	end

	return

OpenURL:
	call pragma('D','')
	
	if( length( result ) > lastpos( ':', result ) ) then do
		completename = insert( '/', completename );
	end
	
	completename = insert( result, completename )
	
	address command 'OpenURL "file://localhost/'completename'"'
return