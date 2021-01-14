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
elseif &t_Co >= 8
  hi Normal  cterm=none ctermfg=none ctermbg=none
  hi Comment cterm=bold ctermfg=240  ctermbg=none
  hi NonText cterm=bold ctermfg=0    ctermbg=none
else
  hi Normal  cterm=none ctermfg=none ctermbg=none
  hi Comment cterm=none ctermfg=none ctermbg=none
  hi NonText cterm=none ctermfg=none ctermbg=none
endif

if &t_Co > 255
  hi Normal  cterm=none ctermfg=245 ctermbg=none gui=NONE guifg=#fcfcfc guibg=#030303
  hi NonText cterm=none ctermfg=246 ctermbg=none gui=NONE guifg=#a0a0a0 guibg=NONE
  hi Comment cterm=none ctermfg=240 ctermbg=none gui=NONE guifg=#a0a0a0 guibg=NONE

  hi Operator   ctermfg=250  ctermbg=none
  hi Constant   ctermfg=none ctermbg=none cterm=none
  hi Boolean    ctermfg=251  ctermbg=none cterm=none
  hi Number     ctermfg=251  ctermbg=none cterm=none
  hi Statement  ctermfg=none ctermbg=none cterm=bold
  hi Identifier ctermfg=none ctermbg=none cterm=none
  hi Function   ctermfg=none ctermbg=none cterm=bold
  hi Title      ctermfg=none ctermbg=none cterm=none
  hi Special    ctermfg=none ctermbg=none cterm=none
  hi Delimiter  ctermfg=none ctermbg=none cterm=none

  hi PreProc    ctermfg=none ctermbg=none cterm=none

  hi Keyword     ctermfg=253  ctermbg=none
  hi Repeat      ctermfg=253  ctermbg=none
  hi Type        ctermfg=253  ctermbg=none
  hi Conditional ctermfg=253  ctermbg=none
  hi Lable       ctermfg=253  ctermbg=none cterm=bold

  " Editor features
  hi LineNr      ctermfg=240  ctermbg=none
  hi ColorColumn ctermfg=none ctermbg=237
  hi Search                   ctermbg=251
  hi Todo       ctermbg=252
  hi Error      ctermfg=254 ctermbg=52 cterm=none
  hi Underlined ctermfg=none ctermbg=none cterm=underline
  hi WildMenu   ctermbg=250
  hi VertSplit  ctermfg=none ctermbg=none cterm=none


  " Completion menu
  hi Pmenu      ctermfg=250 ctermbg=245
  hi PmenuSel   ctermfg=250 ctermbg=255
  hi PmenuThumb ctermfg=81

  hi SpecialComment ctermfg=245 cterm=bold
  hi Special ctermfg=245 cterm=bold

  if has("spell")
    hi SpellBad               ctermbg=52
    hi SpellCap               ctermbg=17
    hi SpellLocal             ctermbg=17
    hi SpellRare ctermfg=none ctermbg=none
  endif

  hi MatchParen ctermbg=240
endif
