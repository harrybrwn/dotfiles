" My Status Line

" TODO:
" generate color scheme based on tmux config

source ~/.vim/util.vim

" Note:
" `darkblue` is nice in solarized dark
" `magenta` is what what my tmux theme has been in the past

" Colors in Statusline:
" User1 -> %1*
" User2 -> %2*
" User3 -> %3*
hi StatusAccent cterm=none ctermbg=magenta ctermfg=black
hi StatusBg     cterm=none ctermbg=none    ctermfg=magenta

let s:agnoster_char = ''
let s:gitbranch_char = ''

fun! GetLineInfo()
  let l:pos = line('$')

  let l:md = mode()
  if l:md == 'v' || l:md == 'V'
      let l:lines = abs(line('v') - line('.')) + 1
      let l:pos .= ' Lines ' . l:lines . ', Chrs ' . wordcount()['visual_chars']
  else
      let l:pos .= ' ln ' . line('.') . ', Col ' . col('.')
  endif

  return l:pos
endfun

fun! UseGitBranch()
  if exists('s:git_branch') && len(s:git_branch) > 0
      return '   ' . s:gitbranch_char . ' ' . s:git_branch . ' '
  else
      return ''
endfun

fun! FileStatus()
    " %f: filename
    " %h: [Help] if in vim help
    " %m: [+] if file is modified
    " %r: [RO] if file is Read Only
    return '%f %m%h%r'
endfun

fun! MyStatusLine()
    let l:line = '%#StatusAccent#%{UseGitBranch()}'

    " if there is more than one buffer, show how many
    if len(getbufinfo({'buflisted':1})) > 1
        let l:line .= '[+%n]'
    endif

    let l:line .= ' '
    let l:line .= FileStatus()
    let l:line .= '%#StatusBg#' . s:agnoster_char
    let l:line .= '%=%#LineNr#'
    let l:line .= '%{GetLineInfo()}  '
    let l:line .= '%#Constant#%y [%{&encoding}]%*'
    return l:line
endfun

