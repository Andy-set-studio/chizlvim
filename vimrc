" Vundle start
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Define plugins
Plugin 'VundleVim/Vundle.vim'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'vim-syntastic/syntastic'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'yegappan/mru'
Plugin 'prettier/vim-prettier'
Plugin 'hankchizljaw/scss-syntax.vim'
Plugin 'isRuslan/vim-es6'
Plugin 'scrooloose/nerdcommenter'
Plugin 'keith/swift.vim'

" Vundle end 
call vundle#end()
filetype plugin indent on

" Set color scheme
colorscheme ChizlPanda 

" Airline theme
let g:airline_theme='base16_grayscale'
let g:airline#extensions#whitespace#enabled = 0

" Fonts n shit
set guifont=Operator\ Mono\ Book:h22
set linespace=2


" Tweaks 
set visualbell t_vb=    " turn off error beep/flash
set novisualbell        " turn off visual bell

" Set core editor settings
set number
set nowrap
set textwidth=0
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
set noswapfile

" Set tab settings
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

" Set syntastic settings
syntax on
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_html_tidy_quiet_messages = { 'level': 'warnings' }
let g:syntastic_javascript_checkers=['eslint']

" Swift settings
let g:syntastic_swift_checkers = ['swiftpm', 'swiftlint']

" Set autocomplete and filetype settings
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType php set omnifunc=phpcomplete#CompletePHP

" Syntax overrides

" Prevent underlines in markup
let html_no_rendering=1

" Prevent comment chars been added on new line creation
" autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Set syntastic to passive mode for html. Shortcut ctrl+w E will make it active: https://stackoverflow.com/a/21434697/2219969
let g:syntastic_mode_map = { 'mode': 'active', 'active_filetypes': [],'passive_filetypes': ['html'] }
nnoremap <C-w>E :SyntasticCheck<CR> :SyntasticToggleMode<CR>
map <C-n> :SyntasticToggleMode<CR>

" Set HTML syntax for odd filetypes
autocmd BufNewFile,BufRead *.html.twig   set syntax=htmldjango
autocmd BufNewFile,BufRead *.njk   set syntax=htmldjango
autocmd BufNewFile,BufRead *.twig   set syntax=htmldjango
autocmd BufNewFile,BufRead *.html   set syntax=htmldjango

" Set Swift indents and stuff 
autocmd FileType swift setlocal tabstop=2 softtabstop=2 shiftwidth=2

" Keymappings

" Toggle NERDTree
map <C-b> :NERDTreeToggle<CR>

" Show most recently opened/edited files
nmap <CR> :MRU<CR>

" NERDCommenter 
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1

" CtrlP settings
set wildignore+=*/tmp/*,*/node_modules/*,*.so,*.swp,*.zip
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.yardoc\|node_modules\|log\|wp-admin\|wp-includes\|tmp\|dist$',
  \ 'file': '\.so$\|\.dat$|\.DS_Store$'
  \ }
" let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" Prettier settings
let g:prettier#config#tab_width = 2
let g:prettier#config#single_quote = 'true'
let g:prettier#config#bracket_spacing = 'false'
let g:prettier#config#tailing_comma = 'false'
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.json,*.md,*.vue,*.css,*.scss Prettier

" Tweak clipboard 
set clipboard=unnamed

" Enable omnicomplete
filetype plugin on
set omnifunc=syntaxcomplete#Complete
set completeopt-=preview

" Show which color scheme settings the highlighted character/word is using 
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Make operator mono do its thing
hi htmlArg gui=italic
hi Comment gui=italic
hi jsxAttrib gui=italic
hi htmlArg cterm=italic
hi Comment cterm=italic
hi jsxAttrib cterm=italic

" Fuck indenting automatically. That’s what prettier is for
:filetype indent off

" Auto-close brackets
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

" Matchit enabled so HTML tags can be matched with %
runtime macros/matchit.vim

" Prevent comment chars been added on new line creation
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
