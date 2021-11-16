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
  " Theme colors
  hi greyLight   cterm=none ctermfg=253 ctermbg=none
  hi greyDark    cterm=none ctermfg=239 ctermbg=none gui=NONE guifg=NONE guibg=NONE
  hi greyBlack   cterm=none ctermfg=16  ctermbg=none
  hi greyWhite   cterm=none ctermfg=255 ctermbg=none
  hi greyStrings cterm=none ctermfg=60 ctermbg=none
  hi greyLiteral cterm=none ctermfg=66 ctermbg=none
  " hi greyControl cterm=none ctermfg=8 ctermbg=none
  hi greyControl cterm=none ctermfg=250 ctermbg=none
  hi greyIdent   cterm=none ctermfg=231 ctermbg=none

  hi Normal  cterm=none ctermfg=245 ctermbg=none gui=NONE guifg=#fcfcfc guibg=#030303
  hi NonText cterm=none ctermfg=246 ctermbg=none gui=NONE guifg=#a0a0a0 guibg=NONE
  hi! link Comment greyDark

  hi Constant   ctermfg=none ctermbg=none cterm=none
  hi Operator   ctermfg=250  ctermbg=none cterm=none
  " hi Identifier ctermfg=none ctermbg=none cterm=none
  hi Function   ctermfg=none ctermbg=none cterm=bold
  " hi Statement  ctermfg=none ctermbg=none cterm=bold
  hi Title      ctermfg=none ctermbg=none cterm=none
  hi Special    ctermfg=none ctermbg=none cterm=none
  hi Delimiter  ctermfg=none ctermbg=none cterm=none
  hi! link Identifier greyIdent
  hi  link Boolean    greyLiteral
  hi  link Number     greyLiteral
  hi  link String     greyStrings

  hi PreProc    ctermfg=59 ctermbg=none cterm=none

  hi link Keyword greyControl
  " hi link Keyword greyBlack
  " hi  link Keyword     greyLight
  hi! link Type        greyLight
  hi  link Conditional Keyword
  hi  link Repeat      Keyword
  hi! link Statement   Keyword
  hi  link Label       Keyword
  " hi! link Label       greyLight

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
  " hi Pmenu      ctermfg=250 ctermbg=245
  hi Pmenu      ctermfg=250 ctermbg=238
  hi PmenuSel   ctermfg=238 ctermbg=255
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

hi greyGreen ctermfg=46 ctermbg=none cterm=none
hi greyBlue ctermfg=45 ctermbg=none cterm=none

" Go
hi! link goBuiltins greyWhite
hi! link goDeclType Keyword
hi! goFormatSpecifier ctermfg=67 ctermbg=none cterm=none
" hi goDeclType ctermfg=8
" hi! link goDirective greyGreen
" hi! link goConstants greyLight
" hi! link goDeclaration grepLight

