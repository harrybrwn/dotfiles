"
" My nvim init
"
" https://github.com/harrybrwn
"

syntax on
set number " line numbers
set wrap
set linebreak
set spelllang=en_us
set bs=2

"set ruler
set colorcolumn=80

" Tab completion
set wildmenu " just looks nice
set wildmode=longest:full,full

" Tab settings
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smartindent

" Old vim packages
packadd! dracula

" Colors
set background=dark
au ColorScheme * highlight Normal ctermbg=none " match terminal background
colorscheme delek " set delek as a fallback
silent! colo molokai
silent! color grey
hi ColorColumn ctermbg=0 " column 80

" Status Line
set laststatus=2  " always show the status line
set noshowmode
set shortmess=filnxtToOFWatc " this if for the bar below the statusline

" Key Mappings
let mapleader=","

" Comments
  nmap <Leader>/ <Plug>NERDCommenterToggle
  xmap <Leader>/ <Plug>NERDCommenterToggle

" Re-map ctrl-j to Esc
  inoremap <C-j> <Esc>
  vnoremap <C-j> <Esc>
  cnoremap <C-j> <C-C>
  nnoremap <C-j> <Esc>

" Window Resizing
  nnoremap <C-w><Up>     <C-w>-
  nnoremap <C-w><C-Up>   <C-w>-
  nnoremap <C-w><Down>   <C-w>+
  nnoremap <C-w><C-Down> <C-w>+
  nnoremap <C-PageUp>   2<C-w>-
  nnoremap <C-PageDown> 2<C-w>+
  nnoremap <C-Home>     2<C-w><
  nnoremap <C-End>      2<C-w>>

" History and Persistant Data
set viminfo=%,'100,<100,s100,h,n~/.config/nvim/viminfo " global paste (with p)
set history=500
set undolevels=1500

" Searching
set path+=** " recursive file search
set hlsearch
set incsearch " get partial results while searching

" Plugins
"   :PlugInstall - install plugins
"   :PlugClean   - clean unused plugins
"   :PlugUpdate  - update plugins
if filereadable(expand('~/.local/share/nvim/site/autoload/plug.vim'))
    call plug#begin('~/.config/nvim/plugins')
    " Languages
    Plug 'fatih/vim-go'                 " Go plugin
    Plug 'vim-pandoc/vim-pandoc'        " Markown stuff with pandoc
    Plug 'vim-pandoc/vim-pandoc-syntax' " Renders markdown files with special characters

    " Themeing
    Plug 'itchyny/lightline.vim'   " status bar theme

    " Misc
    Plug 'preservim/nerdcommenter' " language spesific comments and key mappings
    Plug 'junegunn/vim-easy-align' " auto formatting markdown tables
    call plug#end()
endif

fun PluginExists(name)
  return isdirectory(expand('~/.config/nvim/plugins/' . a:name))
endfun

if PluginExists('nerdcommenter')
    let g:NERDSpaceDelims = 1
endif

if PluginExists('lightline.vim')
    " if PluginExists('itchyny/lightline.vim')
    let g:lightline = {'colorscheme': 'Tomorrow_Night'}
endif

if PluginExists('vim-pandoc')
    au FileType pandoc set syn=pandoc textwidth=80
    let g:pandoc#modules#disabled = ["folding"]
endif

if PluginExists('vim-go')
    let g:go_fmt_command = "goimports"
    nmap <C-g> :GoDef<Cr>
endif
  
" Put these in an autocmd group, so that you can revert them with:
" ":augroup vimStartup | au! | augroup END"
augroup vimStartup
  au!
    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid, when inside an event handler
    " (happens when dropping a file on gvim) and for a commit message (it's
    " likely a different one than last time).
    autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif
augroup END

" XML
au FileType xml setlocal ts=2 sts=2 sw=2 expandtab smartindent

" Pandoc/Markdown color scheme
au FileType pandoc colorscheme dracula
au FileType pandoc hi Normal ctermbg=none

" Yaml
au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml
au FileType yaml setlocal ts=2 sts=2 sw=2 expandtab smartindent
