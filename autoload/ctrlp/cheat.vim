if exists('g:loaded_ctrlp_cheat') && g:loaded_ctrlp_cheat
  finish
endif
let g:loaded_ctrlp_cheat = 1

let s:cheat_var = {
\  'init':   'ctrlp#cheat#init()',
\  'exit':   'ctrlp#cheat#exit()',
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

let s:cache_dir = ctrlp#utils#cachedir() . ctrlp#utils#lash() . 'cheat'
let s:cache_file = s:cache_dir . ctrlp#utils#lash() . 'cache.txt'

function! ctrlp#cheat#init()
  return split(system("cheat list"), "\n")
endfunc

function! ctrlp#cheat#accept(mode, str)
  call ctrlp#exit()
  exe "Cheat" a:str
endfunction

function! ctrlp#cheat#exit()
  if s:cache_enabled
    let lines = [printf('{"root" : %s}',string(s:root))] + s:repos
    call ctrlp#utils#writecache(lines, s:cache_dir, s:cache_file)
  endif
endfunction

function! ctrlp#cheat#reload()
  if !s:check_cache_date()
    let s:root = s:get_root()
  endif
  let s:repos = s:get_repos()
endfunction

function! s:init()
  let s:root = ''
  let s:repos = []

  if s:cache_enabled && s:check_cache_date()
    let lines = ctrlp#utils#readfile(s:cache_file)
    let s:root = s:validate(lines)
    if !empty(s:root)
      let s:repos = lines[1:]
    endif
  endif

  if empty(s:root)
    let s:root = s:get_root()
  endif
endfunction

function! s:check_cache_date()
  return filereadable(s:cache_file) &&
        \ getftime(s:cache_file) >= getftime(expand('~/.gitconfig'))
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#cheat#id()
  return s:id
endfunction

" vim:fen:fdl=0:ts=2:sw=2:sts=2
