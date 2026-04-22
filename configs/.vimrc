" Configuração Básica Vim
set number
set relativenumber
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent
set syntax=on
set hlsearch
set incsearch
set showmatch
set ruler
set laststatus=2

" Cores
syntax on
colorscheme default

" Mapeamentos básicos
let mapleader = ","
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>e :Explore<CR>

" Busca case insensitive
set ignorecase
set smartcase

