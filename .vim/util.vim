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

vnoremap <Leader>/ :call Comment(g:comment_char)<cr>

fun! UpdateGitBranch()
    let s:git_branch = system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfun

let s:gitbranch_char = ''

augroup GitBranchUpdate
  " We dont want to update the git branch in the status line
  " every time the status line refreshes so these auto commands
  " update the branch variable when it is important.

  "au!
  "au BufNewFile,BufWritePost,BufReadPost      * call UpdateGitBranch()
  "au InsertEnter,InsertLeave,InsertChange     * call UpdateGitBranch()
  "au CmdlineChanged,CmdlineEnter,CmdlineLeave * call UpdateGitBranch()
  "au CursorHold,CursorHoldI  * call UpdateGitBranch()
  "au WinEnter,WinLeave       * call UpdateGitBranch()
  "au CmdwinEnter,CmdwinLeave * call UpdateGitBranch()
augroup END

