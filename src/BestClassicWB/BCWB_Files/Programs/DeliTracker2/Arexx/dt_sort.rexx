/*
 * dt_sort.rexx
 *  $VER: 1.1
 *  05-Feb-95
 *  © Delirium Softdesign
 *
 * An ARexx script for sorting large module directories
 *
 * Usage: dt_sort.rexx <dir>
 *
 */


/* standard setup */
options results
options failat 20

/* get arguments */
parse arg directory .

/* create the directory name */
if directory == '' then do
  directory = pragma('D')
end
if right(directory,1) ~== ':' then do
  if index(directory,':') == '0' then do
    if right(pragma('D'),1) ~== ':' then do
      directory = '/'||directory
    end
  directory = pragma('D')||directory
  end
  if right(directory,1) ~== '/' then do
    directory = directory||'/'
  end
end

/* test, if the directory is vaild */
if exists(directory) == '0' then do
  say 'invalid directory'
  exit 10
end

/* test, if DeliTracker is running */
if show('P','DELITRACKER') == '0' then do
  say 'DeliTracker is not running'
  exit 10
end

/* add the functions of the 'rexxsupport.library' */
if addlib('rexxsupport.library',0,-30,0) == '0' then do
  if show('L','rexxsupport.library') == '0' then do
    say 'couldn''t open rexxsupport.library'
    exit 10
  end
end

/* get the contents of the module directory */
modlist = showdir(directory,'F',':')||':'

say 'sorting modules'

address 'DELITRACKER'

/* store quickstart state */
status G qst
quickstart = result

/* do not play the modules after loading */
quick no

/* eject the old module */
eject

/* process the module directory */
do until (modlist == '')

  filename = left(modlist,index(modlist,':')-1)
  modlist = delstr(modlist,1,index(modlist,':'))

  if filename ~== '' then do

    playmod directory||filename

    status M pna
    playernam = result

    if playernam == '' then do
      say 'could not identify "'||filename||'"'
    end
    else do

      status M fmt
      playername = result

      /* create a new directory if necessary */
      if exists(directory||playername) == '0' then do
        say 'module directory "'||playername||'" did not exist. It was created.'
        CALL makedir(directory||playername)
      end

      /* move the module into the specific directory */
      if exists(directory||playername||'/'||filename) == '0' then do
        say 'moving "'||filename||'" into the '||playername||' directory'
        CALL rename(directory||filename,directory||playername||'/'||filename)
      end
      else do
        say 'module "'||filename||'" is already in the "'||playername||'" directory'
      end

    end

    eject

  end

end

/* restore quickstart state */
quick quickstart

address 'REXX'

say 'all done'

/* remove the functions of the 'rexxsupport.library' */
remlib('rexxsupport.library')

/* end of script */
exit 0

