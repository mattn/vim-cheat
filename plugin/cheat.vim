command! -bang -nargs=? -complete=customlist,cheat#list Cheat call cheat#show('<bang>', <q-args>)
