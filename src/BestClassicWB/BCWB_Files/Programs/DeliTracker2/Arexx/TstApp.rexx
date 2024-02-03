/* 

NAME
     TstApp - A convenient way to test an application's ARexx port.

SYNOPSIS
     [rx] tstapp <port> [<screen>]

DESCRIPTION
     Provides a convenient way to test an application's ARexx port.
     TstApp opens a window through which you can type commands that
     are fed directly to the ARexx port <port>.  The return code
     RC and the RESULTS variable, if applicable, are written to
     the window after the application replies to the message.

     <port> must be a valid ARexx port.

     <screen> is an optional hex address of the screen to open
     the window on.  Or, a <screen> value of 'front' will cause
     the window to be opened on the front screen.  The <screen>
     parameter requires ConMan to be installed.  It's probably 
     possible to devise code using pure ARexx that will find the
     address of the screen given the name of the screen, but I'd
     prefer not to muck around quite that much, since it's probably 
     dangerous to go walking system lists without Forbid() and
     Permit().  Just juggle screens and use the 'front' option.
     And be careful not to close the screen before quitting TstApp!

     TstApp recognizes two commands:  '\res' and '\end'.  Typing
     '\res' toggles the status of OPTIONS RESULTS.  Typing '\end'
     exits TstApp and closes the window.

AUTHOR
     TstApp is public domain by Eric Kennedy.  Hope it helps you
     debug your ARexx compatible program, or helps you figure out
     how to use those that you already have.

*/

trace off
options
parse arg appname screen

if appname = "" then
do
  say "Usage: rx tstapp <port> [<screen>]"
  say 
  say "<port> must be a valid ARexx port."
  say "<screen> is an optional hex address of the screen to open"
  say "the window on.  Or, a <screen> value of 'front' will cause"
  say "the window to be opened on the front screen.  The <screen>"
  say "parameter requires ConMan to be installed."
  exit
end

if screen~="" then
do
  if upper(screen)='FRONT' then screen = 'S*/' 
  else screen='S'||subword(screen,1,1)||'/'    
end

if ~Open(MYCON,'CON:'||screen||'100/50/450/125/'||appname||'_test') then
do
  say "Can't open window!"
  exit
end

call writeln(MYCON,'Type command for' appname || '. \end to quit')
call writeln(MYCON,'Type \res to toggle OPTIONS RESULTS.')
call writeln(MYCON,'OPTIONS RESULTS is off.')

r='n'    /* options results off */

address VALUE appname 
do while inp ~= '\end'
  call writech(MYCON,appname||'> ')
  inp = readln(MYCON)
  if inp ~= '\end' then do
    if inp = '\res' then do
	  if r = 'y' then do
	    options
		r = 'n'
        call writeln(MYCON,'OPTIONS RESULTS is off.')
      end 
	  else do
	    options results
		r = 'y'
        call writeln(MYCON,'OPTIONS RESULTS is on.')
      end
	end
    else do
	  inp
      res=result
      call writeln(MYCON,'RC----->'||RC)
      if r = 'y' then do
	    call writeln(MYCON,'result->'||res)
      end
    end
  end
end
