/* EaglePlayer - Lade angegebenes Engine hinein */

parse arg enginename

address 'rexx_EP'

options results

adduserprg enginename

say 'Eagleplayer: '||result
end
