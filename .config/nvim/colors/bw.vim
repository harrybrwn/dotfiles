" bw-onedark.vim
" By Michał Góral
"
" This theme is based on Fogbell by Jared Gorski, which is available
" here: https://github.com/jaredgorski/fogbell
" Also on onedark.vim: https://github.com/joshdick/onedark.vim

scriptencoding utf-8
hi clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name="bw-onedark"

" ==========================
" Color Variables
" ==========================

let c = {}
let c.black = {'gui': '#282c34', 'cterm256': '235'}
let c.white = {'gui': '#ABB2BF', 'cterm256': '145'}
let c.light_white = {'gui': '#dbdcdf', 'cterm256': '248'}
let c.gray = {'gui': '#2C323C', 'cterm256': '236'}
let c.medium_gray = {'gui': '#4B5263', 'cterm256': '238'}
let c.dark_gray = {'gui': '#5C6370', 'cterm256': '59'}
let c.bright_white = {'gui': '#ECEFF4', 'cterm256': '252'}
let c.blue = {'gui': '#81A1C1', 'cterm256': '39'}
let c.green = {'gui': '#98C379', 'cterm256': '114'}
let c.gold = {'gui': '#E5C07B', 'cterm256': '180'}
let c.red = {'gui': '#E06C75', 'cterm256': '204'}
let c.purple = {'gui': '#C678DD', 'cterm256': '170'}
let c.none = {'gui': 'NONE', 'cterm256': 'NONE'}

call bw#init(c)
