function! cheat#list(a, l, p) abort
  return filter(split(system(get(g:, "cheat_list_command", "cheat list")), "\n"), "stridx(v:val, a:a)==0")
endfunction

function! cheat#show(c) abort
  let ret = system(printf(get(g:, "cheat_show_command", "cheat show %s"), shellescape(a:c)))
  if v:shell_error
    return
  endif
  let bnr = bufnr("__CHEAT__")
  if bnr == -1
    silent execute get(g:, "cheat_height", "") . "new __CHEAT__"
    setlocal filetype=cheat
    setlocal bufhidden=hide
    setlocal buftype=nofile
    setlocal nobuflisted
    setlocal foldcolumn=0
    setlocal nofoldenable
    setlocal nonumber
    setlocal noswapfile
    setlocal winfixheight
    if get(g:, "cheat_autohide")
      autocmd BufLeave <buffer> exe bnr . "bdelete!" 
    endif
  else
    let wnr = bufwinnr(bnr)
    if wnr != -1
      if winnr() != wnr
        exe wnr . "wincmd w"
      endif
    else
      execute get(g:, "cheat_height", "") . "split +buffer" . bnr
    endif
  endif
  silent! %d _
  call setline(1, map(split(ret, "\n"), 'substitute(v:val, "\x1b[.\\{-}m", "", "g")'))
endfunction
