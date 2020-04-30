" Vundle start
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Define plugins
Plugin 'VundleVim/Vundle.vim'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'vim-syntastic/syntastic'
Plugin 'sheerun/vim-polyglot'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'hail2u/vim-css3-syntax'
Plugin 'godlygeek/tabular'
Plugin 'scrooloose/nerdcommenter'
Plugin 'yegappan/mru'
Plugin 'Yggdroot/indentLine'
Plugin 'chrisbra/Colorizer'
Plugin 'heavenshell/vim-jsdoc'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'prettier/vim-prettier'
Plugin 'sumpygump/php-documentor-vim'
Plugin 'cakebaker/scss-syntax.vim'
Plugin 'alexlafroscia/postcss-syntax.vim'
Plugin 'posva/vim-vue'
Plugin 'Quramy/vim-js-pretty-template'
Plugin 'junegunn/goyo.vim'

" Vundle end 
call vundle#end()
filetype plugin indent on

" Set color scheme
colorscheme ChizlPanda

" Airline theme
let g:airline_theme='tomorrow'

" Set core editor settings
set number
set nowrap
set showbreak=+++
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

" Set vim-jsx settings
let g:jsx_ext_required = 0
highlight link xmlEndTag xmlTag

" JS setting 
let g:javascript_plugin_jsdoc = 1
let g:jsdoc_enable_es6=1

" Set UltiSnips settings
let g:UltiSnipsExpandTrigger='<tab>'
let g:UltiSnipsJumpForwardTrigger='<c-b>'
let g:UltiSnipsJumpBackwardTrigger='<c-z>'
let g:UltiSnipsEditSplit='vertical'
let g:UltiSnipsSnippetDirectories=['UltiSnips']

" Set autocomplete and filetype settings
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType php set omnifunc=phpcomplete#CompletePHP

" Set Markdown to be pain text 
autocmd FileType markdown set ft=text

" Syntax overrides

" Prevent underlines in markup
let html_no_rendering=1

" Prevent comment chars been added on new line creation
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" When a curly brace pair is added, add a new tabbed line inside them
"inoremap {<CR> {<CR>}<Esc>O<BS><Tab>

" Set syntastic to passive mode for html. Shortcut ctrl+w E will make it active: https://stackoverflow.com/a/21434697/2219969
let g:syntastic_mode_map = { 'mode': 'active', 'active_filetypes': [],'passive_filetypes': ['html'] }
nnoremap <C-w>E :SyntasticCheck<CR> :SyntasticToggleMode<CR>
map <C-n> :SyntasticToggleMode<CR>

" Set HTML syntax for odd filetypes
autocmd BufNewFile,BufRead *.html.twig   set syntax=htmldjango
autocmd BufNewFile,BufRead *.njk   set syntax=htmldjango
autocmd BufNewFile,BufRead *.html   set syntax=htmldjango

" Keymappings

" Toggle NERDTree
map <C-b> :NERDTreeToggle<CR>

" Run Tabular align function. After you need to provide the separator such as = or : or =>
map <C-a> :Tab /

" Show most recently opened/edited files
map <C-m> :MRU<CR>

" Highlight document colors 
map <C-h> :ColorHighlight<CR>

" Add a JS Doc
map <C-j> :JsDoc<CR>

" Add a PHP doc
au BufRead,BufNewFile *.php inoremap <buffer> <C-j> :call PhpDoc()<CR>
au BufRead,BufNewFile *.php nnoremap <buffer> <C-j> :call PhpDoc()<CR>
au BufRead,BufNewFile *.php vnoremap <buffer> <C-j> :call PhpDocRange()<CR>

" NERDCommenter 
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1

" CtrlP settings
set wildignore+=*/tmp/*,*/node_modules/*,*.so,*.swp,*.zip
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" Prettier settings
let g:prettier#config#tab_width = 2
let g:prettier#config#single_quote = 'true'
let g:prettier#config#bracket_spacing = 'false'
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.json,*.md,*.vue,*.css,*.scss PrettierAsync

" Vue settings
autocmd BufRead,BufNewFile *.vue setlocal filetype=vue.html.javascript.css
let g:vue_disable_pre_processors=1

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

" Emmet 
imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")

" Allow project specific vimrc files
set exrc
set secure

" delete without yanking
nnoremap <leader>d "_d
vnoremap <leader>d "_d

" replace currently selected text with default register
" without yanking it
vnoremap <leader>p "_dP

" Tagged template literal syntax
call jspretmpl#register_tag('html', 'html')
autocmd FileType javascript JsPreTmpl
autocmd FileType javascript.jsx JsPreTmpl

" Fuck indenting automatically. That’s what prettier is for
:filetype indent off

" Auto-close brackets
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

" Matchit enabled so HTML tags can be matched with %
runtime macros/matchit.vim

