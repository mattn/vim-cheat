function! cheat#list(a, l, p) abort
  return filter(split(system(get(g:, "cheat_list_command", "cheat list")), "\n"), "stridx(v:val, a:a)==0")
endfunction

function! cheat#show(b, c) abort
  if a:c == ''
    if exists(':CtrlP')
      call ctrlp#init(ctrlp#cheat#id())
    endif
    return
  endif
  if a:b != ''
    try
      for d in webapi#json#decode(join(readfile(expand('~/.cheatrc')), "\n"))['cheatdirs']
        let p = d . '/' . a:c
		echo p
        if filereadable(p)
          exec "split" p
          return
        endif
      endfor
    catch
    endtry
  endif
  let ret = system(printf(get(g:, "cheat_show_command", "cheat show %s"), shellescape(a:c)))
  if v:shell_error
    return
  endif
  let bnr = bufnr("__CHEAT__")
  if bnr == -1
    silent exe get(g:, "cheat_height", "") . "new __CHEAT__"
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
      let bnr = bufnr("__CHEAT__")
      exe "autocmd BufLeave <buffer> " . bnr . "bdelete!"
    endif
  else
    let wnr = bufwinnr(bnr)
    if wnr != -1
      if winnr() != wnr
        exe wnr . "wincmd w"
      endif
    else
      exe get(g:, "cheat_height", "") . "split +buffer" . bnr
    endif
  endif
  silent! %d _
  call setline(1, map(split(ret, "\n"), 'substitute(v:val, "\x1b[.\\{-}m", "", "g")'))
endfunction
