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
set smartindent
set smarttab
set ruler
set undolevels=1000
set backspace=indent,eol,start

" Set tab settings
set autoindent
set noexpandtab
set tabstop=4
set shiftwidth=4
filetype plugin indent on

" Set indent guide
set listchars=tab:\¦\ 
set list

" Set pathogen settings
execute pathogen#infect()

" Set syntastic settings
syntax on
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

