" function UpdateGitBranch()
"     let g:git_branch = system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
" endfunction


function! Comment(cmnt_str)
  if a:cmnt_str == ''
    return
  endif

  let l:len = len(a:cmnt_str) + 1
  let l:prev = getpos(".")
  let l:col = prev[2]

  normal! ^
  let l:ch = matchstr(getline('.'), '\%' . col('.') . 'c' . repeat('.', l:len - 1))

  if l:ch == a:cmnt_str
    execute 'normal!' . l:len . 'x'
    let l:col -= l:len
  else
    execute "normal! i" . a:cmnt_str . " "
    let l:col += l:len
  endif

  call cursor(prev[1], l:col)
endfunction
