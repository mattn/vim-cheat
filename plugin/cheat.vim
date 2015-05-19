command! -nargs=1 -complete=customlist,cheat#list Cheat call cheat#show(<q-args>)
