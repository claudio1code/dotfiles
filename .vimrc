" Vim settings
" Milis
" UTF-8 by default
set encoding=utf-8

" Highlight search results
set hlsearch

" Enable incremental search
set incsearch

" show line numbers
set number

" status line
set laststatus=2

" color scheme
colorscheme desert

" code completion
set wildmenu

" tab size
set tabstop=4
set shiftwidth=4
set expandtab

" auto-indent
set autoindent

" syntax highlighting
syntax on

" filetype detection
filetype on
filetype plugin indent on

" Persistent undo
set undodir=~/.vim/undodir
set undofile

" Sets how many lines of history VIM has to remember
set history=1000

" Set to auto read when a file is changed from the outside
set autoread

" Turn on wild menu
set wildmenu

" show matching brackets
set showmatch

" Show current position in file
set ruler

" Blink cursor on error instead of beeping (grr)
set visualbell

" Enable mouse support
set mouse=a

" Plugins
call plug#begin('~/.vim/plugged')

" File explorer
Plug 'preservim/nerdtree'

" Status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Color scheme
Plug 'dracula/vim'

" Autocomplete
Plug 'lifepillar/vim-mucomplete'

call plug#end()

" Dracula colorscheme
colorscheme dracula

" NERDTree configuration
" Start NERDTree automatically when Vim starts up
" autocmd VimEnter * NERDTree
" Start NERDTree automatically when Vim starts up on opening a directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' | endif
" Close Vim if NERDTree is the only window left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Open NERDTree with Ctrl+n
map <C-n> :NERDTreeToggle<CR>

" vim-mucomplete configuration
" Enable auto-completion
set completeopt=menuone,noselect