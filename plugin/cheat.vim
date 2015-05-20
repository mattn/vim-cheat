command! -nargs=? -complete=customlist,cheat#list Cheat call cheat#show(<q-args>)
