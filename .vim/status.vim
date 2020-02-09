" hi User2 ctermbg=none ctermfg=darkcyan guibg=green guifg=red
" hi User3 ctermbg=none ctermfg=darkcyan guibg=blue  guifg=green
" hi User1 ctermbg=darkgray ctermfg=cyan guibg=grey guifg=white

source ~/.vim/util.vim

" TODO:
" generate color scheme based on tmux config

" Note:
" `darkblue` is nice in solarized dark
" `magenta` is what what my tmux theme has been in the past

hi User1 ctermbg=magenta ctermfg=black
hi User2 ctermbg=none ctermfg=magenta
hi User3 ctermbg=none ctermfg=grey

let g:git_branch = GitBranch()

au BufNewFile,
 \ BufReadPost,
 \ BufWritePost,
 \ InsertEnter,
 \ InsertLeave,
 \ CursorHold,
 \ CursorHoldI
 \ * let g:git_branch = GitBranch()

function! UseGitBranch()
  if strlen(g:git_branch) > 0
      return '   ' . g:git_branch . ' '
  else
      return ''
endfunction

set statusline=%1*          " User1 highlighting
set statusline+=%{UseGitBranch()}
set statusline+=[+%n]
set statusline+=\ %f         " file name
set statusline+=%h%m%r\      " file status flags
set statusline+=%2*          " User2 highlighting
set statusline+=            " like agnoster from zsh
set statusline+=%#Constant#  " same color as editor background
set statusline+=%=           " go to other side
set statusline+=%2*          " User3 highlighting
set statusline+=%y           " filetype
set statusline+=\ \[%{&encoding}\]\ %p%%\ %l:%c
set statusline+=%*  " reset statusline highlighting

