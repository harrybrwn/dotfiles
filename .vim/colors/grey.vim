"
" Author: Harry Brown
"
set background=dark
if v:version > 580
  highlight clear
  if exists('g:syntax_on')
    syntax reset
  endif
endif
let g:colors_name = 'grey'

if has('gui_running') || &t_Co >= 256
  "hi Normal  cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=#fcfcfc guibg=#030303
  hi Normal  cterm=NONE ctermfg=245 ctermbg=NONE gui=NONE guifg=#fcfcfc guibg=#030303
  hi Comment cterm=NONE ctermfg=240  ctermbg=NONE gui=NONE guifg=#a0a0a0 guibg=NONE
  hi NonText cterm=NONE ctermfg=246  ctermbg=NONE gui=NONE guifg=#a0a0a0 guibg=NONE
elseif &t_Co >= 8
  hi Normal  cterm=NONE ctermfg=NONE ctermbg=NONE
  hi Comment cterm=bold ctermfg=240  ctermbg=NONE
  hi NonText cterm=bold ctermfg=0    ctermbg=NONE
else
  hi Normal  cterm=NONE ctermfg=NONE ctermbg=NONE
  hi Comment cterm=NONE ctermfg=NONE ctermbg=NONE
  hi NonText cterm=NONE ctermfg=NONE ctermbg=NONE
endif

hi Constant   cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Identifier cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Function   cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Statement  cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi PreProc    cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Type       cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Title      cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Special    cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
hi Delimiter  cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE

hi LineNr  ctermfg=240 ctermbg=none
hi Keyword     ctermfg=251 ctermbg=none
hi Repeat      ctermfg=251 ctermbg=none
hi Type        ctermfg=250 ctermbg=none
hi Conditional ctermfg=251 ctermbg=none
hi Boolean     ctermfg=251 ctermbg=none
hi Operator    ctermfg=245 ctermbg=none

