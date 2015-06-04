if exists('g:loaded_ctrlp_cheat') && g:loaded_ctrlp_cheat
  finish
endif
let g:loaded_ctrlp_cheat = 1

let s:cheat_var = {
\  'init':   'ctrlp#cheat#init()',
\  'accept': 'ctrlp#cheat#accept',
\  'lname':  'cheat',
\  'sname':  'cheat',
\  'type':   'path',
\  'sort':   0,
\  'nolim':  1,
\}

if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
  let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:cheat_var)
else
  let g:ctrlp_ext_vars = [s:cheat_var]
endif

let s:cheat_command = get(g:, 'ctrlp_cheat_command', 'cheat')
let s:cache_enabled = get(g:, 'ctrlp_cheat_cache_enabled', 0)

function! ctrlp#cheat#init()
  return split(system("cheat list"), "\n")
endfunc

function! ctrlp#cheat#accept(mode, str)
  call ctrlp#exit()
  exe "Cheat" a:str
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#cheat#id()
  return s:id
endfunction

" vim:fen:fdl=0:ts=2:sw=2:sts=2
