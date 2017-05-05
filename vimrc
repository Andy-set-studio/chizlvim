" Set color scheme
colorscheme Tomorrow-Night

" Set core editor settings
set number
set nowrap
set showbreak=+++
set textwidth=100
set showmatch
set visualbell
set hlsearch
set smartcase
set ignorecase
set incsearch
set autoindent
set expandtab
set shiftwidth=4
set smartindent
set smarttab
set softtabstop=4
set tabstop=4
set ruler
set undolevels=1000
set backspace=indent,eol,start

syntax on
filetype plugin indent on

" Set pathogen settings
execute pathogen#infect()

" Set syntastic settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
