/* Extend the system ARC DefIcons rule for stored .arc files. */
file = 'SYS:Prefs/Env-Archive/deficons.prefs'
backup = 'T:BCWB-DefIcons.backup'
staged = 'T:BCWB-DefIcons.new'
data = readFile(file)
if data = '' then exit 0

/* DefIcons preferences are a single data hunk followed by HUNK_END. */
header = '000003F300000000000000010000000000000000'x
dataTag = '000003EA'x
endTag = '000003F2'x
words = (length(data) - 36) / 4
if words < 1 | words ~= trunc(words) then exit 0
if left(data, 20) ~= header | right(data, 4) ~= endTag then exit 0
if substr(data, 21, 12) ~= d2c(words, 4) || dataTag || d2c(words, 4) then exit 0

arc = 'arc' || '00010000021A08'x
arj = '00'x || 'arj' || '000100000260EA00'x
rule = arc || arj
at = pos(rule, data, 33)
if at = 0 then exit 0
if pos(rule, data, at + length(rule)) ~= 0 then exit 0

/* Keep the original match and add a stored header with an ARC suffix. */
stored = '07010000021A0205'x || '#?.arc' || '00'x
body = substr(data, 33, at + length(arc) - 33) || stored ||,
       substr(data, at + length(arc), length(data) - at - length(arc) - 3) || '00'x
words = length(body) / 4
patched = header || d2c(words, 4) || dataTag || d2c(words, 4) || body || endTag

if exists(backup) | exists(staged) then do
    say 'DefIcons temporary files already exist. Preferences were left intact.'
    exit 5
end
address command 'C:Copy "'file'" TO "'backup'" CLONE QUIET'
if rc ~= 0 then exit 5
address command 'C:Copy "'backup'" TO "'staged'" CLONE QUIET'
if rc ~= 0 then signal failed
if ~open('out', staged, 'A') then signal failed
position = seek('out', 0, 'B')
if position >= 0 then written = writech('out', patched)
else written = -1
call close 'out'
if written ~= length(patched) | readFile(staged) ~= patched then signal failed

address command 'C:Copy "'staged'" TO "'file'" CLONE QUIET'
if rc ~= 0 | readFile(file) ~= patched then do
    address command 'C:Copy "'backup'" TO "'file'" CLONE QUIET'
    if rc ~= 0 then do
        say 'Could not restore DefIcons preferences. Original saved in' backup
        exit 20
    end
    signal failed
end
address command 'C:Delete "'backup'" "'staged'" QUIET FORCE'
exit 0

failed:
say 'Could not update the ARC DefIcons rule. The original preferences are intact.'
address command 'C:Delete "'backup'" "'staged'" QUIET FORCE'
exit 5

readFile: procedure
    parse arg path
    if ~open('in', path, 'R') then return ''
    bytes = readch('in', 65536)
    call close 'in'
    return bytes

