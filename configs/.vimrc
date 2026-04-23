set nocompatible
filetype on
syntax on
set mouse=a
set number
set cursorline
set hidden
set shiftwidth=4
set tabstop=4
set expandtab
set history=1000
set nobackup
set nowritebackup
set directory=~/.vim/swapfiles//
set updatetime=300
set noerrorbells
set visualbell
set t_vb=
set ignorecase
set smartcase
set incsearch
set hlsearch
set wildmenu
set wildmode=list:longest
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
let mapleader = "\<Space>"

call plug#begin()

Plug 'bluz71/vim-moonfly-colors', { 'as': 'moonfly' }
Plug 'jayli/vim-easycomplete'
Plug 'L3MON4D3/LuaSnip'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'preservim/tagbar'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-commentary'
Plug 'airblade/vim-gitgutter'

call plug#end()

colorscheme moonfly

let g:easycomplete_tabnine_enable = 1
let g:easycomplete_lsp_checking = 0
noremap gr :EasyCompleteReference<CR>
noremap gd :EasyCompleteGotoDefinition<CR>
noremap rn :EasyCompleteRename<CR>
noremap gh :EasyCompleteHover<CR>
noremap gb :BackToOriginalBuffer<CR>

let g:netrw_banner = 0
map <silent> <leader>dd :Explore<CR>

nnoremap <leader>ff :Files<CR>
nnoremap <leader>fg :Rg<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fh :Helptags<CR>
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-s': 'vsplit' }

let g:tagbar_autofocus = 1
nmap <F8> :TagbarToggle<CR>
