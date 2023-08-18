"
" Author: Harry Brown
"
if v:version > 580
  highlight clear
  if exists('g:syntax_on')
    syntax reset
  endif
endif
let g:colors_name = 'grey'

if has('gui_running') || &t_Co >= 256
  " hi Normal  cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=#fcfcfc guibg=#030303
elseif &t_Co >= 8
  hi Normal  cterm=none ctermfg=none ctermbg=none guifg=none guibg=none
  " hi Comment cterm=bold ctermfg=240  ctermbg=none guifg=#f0f0f0  guibg=none
  hi NonText cterm=bold ctermfg=0    ctermbg=none guifg=0    guibg=none
else
  hi Normal  cterm=none ctermfg=none ctermbg=none guifg=none guibg=none
  hi Comment cterm=none ctermfg=none ctermbg=none guifg=none guibg=none
  hi NonText cterm=none ctermfg=none ctermbg=none guifg=none guibg=none
endif

if &t_Co > 255
  " Theme colors
  hi greyLight   cterm=none ctermfg=253 ctermbg=none guifg=#fdfdfd guibg=none
  hi greyDark    cterm=none ctermfg=239 ctermbg=none guifg=#efefef guibg=NONE
  hi greyBlack   cterm=none ctermfg=16  ctermbg=none guifg=#101010 guibg=none
  hi greyWhite   cterm=none ctermfg=255 ctermbg=none guifg=#ffffff guibg=none
  hi greyStrings cterm=none ctermfg=60  ctermbg=none guifg=#3c3c3c guibg=none
  hi greyLiteral cterm=none ctermfg=66  ctermbg=none guifg=#424242 guibg=none
  hi greyControl cterm=none ctermfg=250 ctermbg=none guifg=#fafafa guibg=none
  hi greyIdent   cterm=none ctermfg=231 ctermbg=none guifg=#e7e7e7 guibg=none

  hi Normal cterm=none ctermfg=245 ctermbg=none guifg=#f5f5f5 guibg=none
  hi NonText cterm=none ctermfg=246 ctermbg=none gui=NONE guifg=#a0a0a0 guibg=NONE
  hi! link Comment greyDark

  hi Constant   ctermfg=none ctermbg=none cterm=none guifg=none guibg=none
  hi Function   ctermfg=none ctermbg=none cterm=bold guifg=none guibg=none
  "hi Statement  ctermfg=none ctermbg=none cterm=bold
  hi Title      ctermfg=none ctermbg=none cterm=none guifg=none guibg=none
  hi Special    ctermfg=none ctermbg=none cterm=none guifg=none guibg=none
  hi Delimiter  ctermfg=none ctermbg=none cterm=none guifg=none guibg=none
  hi! link Identifier greyIdent
  hi  link Boolean    greyLiteral
  hi  link Number     greyLiteral
  hi  link String     greyStrings

  hi PreProc    ctermfg=59 ctermbg=none cterm=none guifg=#3b3b3b guibg=none

  hi link Keyword greyControl
  " hi link Keyword greyBlack
  " hi  link Keyword     greyLight
  hi! link Type        greyLight
  hi  link Conditional Keyword
  hi  link Repeat      Keyword
  hi! link Statement   Keyword
  hi  link Label       Keyword

  " Editor features
  hi LineNr      ctermfg=240  ctermbg=none guifg=240 guibg=none
  hi SignColumn  ctermfg=240  ctermbg=none guifg=240 guibg=none " SignColumn is the column that is to the left of the line numbers.
  hi ColorColumn ctermfg=none ctermbg=237 guifg=none guibg=237
  hi Search                   ctermbg=251            guibg=251
  hi Todo       ctermbg=252 guibg=252
  hi Error      ctermfg=254 ctermbg=52 cterm=none guifg=254 guibg=52
  hi Underlined ctermfg=none ctermbg=none cterm=underline guifg=none guibg=none gui=underline
  hi WildMenu   ctermbg=250 guibg=250
  hi VertSplit  ctermfg=none ctermbg=none cterm=none guifg=none guibg=none

  " Tabs
  " hi TabLine     ctermfg=black ctermbg=grey guifg=none guibg=none
  hi TabLineSel  ctermfg=black ctermbg=grey guifg=none guibg=none
  hi link TabLine Comment
  hi TabLineFill ctermfg=black ctermbg=grey guifg=black guibg=grey

  " Completion menu
  " hi Pmenu      ctermfg=250 ctermbg=245
  hi Pmenu      ctermfg=250 ctermbg=238
  hi PmenuSel   ctermfg=238 ctermbg=255
  hi PmenuThumb ctermfg=81

  hi SpecialComment ctermfg=245 cterm=bold guifg=#f5f5f5
  hi Special ctermfg=245 cterm=bold

  if has("spell")
    hi SpellBad               ctermbg=52
    hi SpellCap               ctermbg=17
    hi SpellLocal             ctermbg=17
    hi SpellRare ctermfg=none ctermbg=none
  endif

  hi MatchParen ctermbg=240
  hi Directory ctermfg=250 ctermbg=none guifg=250 guibg=none
endif

hi greyGreen ctermfg=46 ctermbg=none cterm=none
hi greyBlue ctermfg=45 ctermbg=none cterm=none

" Go
hi! link goBuiltins greyWhite
hi! link goDeclType Keyword
hi! goFormatSpecifier ctermfg=67 ctermbg=none cterm=none

