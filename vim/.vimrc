" ================ General Configuration ==============
"
set nocompatible     	 " We're running Vim, not Vi!
set term=screen-256color
syntax on             	" Enable syntax highlighting
filetype on           	" Enable filetype detection
filetype indent on    	" Enable filetype-specific indenting
filetype plugin on    	" Enable filetype-specific plugins
set nrformats=          " Disables Vim's built in octal-numeric system. All numbers if containing leading zero now decimal format
set hls
set wildmenu
set wildmode=full
set history=1000
set fileformat=unix
set showcmd             "Show incomplete cmds down the bottom
set showmode            "Show current mode down the bottom
set visualbell          "No sounds
set autoread            "Reload files changed outside vim
set backspace=2         "Make backspace work like most other apps
set number              "display line numbers on the left
set clipboard=unnamed

" ================ Un-map Arrow Keys ==============
"
noremap <Up>    <Nop>
noremap <Down>  <Nop>
noremap <Left>  <Nop>
noremap <Right> <Nop>

" ================ Turn Off Swap Files ==============
"
set noswapfile
set nobackup
set nowb

" ================ Search ===========================
"
set incsearch       " Find the next match as we type the search
set hlsearch        " Highlight searches by default
set ignorecase      " Ignore case when searching...
set smartcase       " ...unless we type a capital
noremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

" ================ Leader-Key ===========================
"
let mapleader = ","
let maplocalleader = "\\"

" ================ Re-map Escape ===========================
"
" Map escape
:imap kj <Esc>

" ================ Textwidth/Spellchecker ==============
"
" highlight when over 80 characters
"highlight Overlength ctermbg=red ctermfg=white
"match Overlength /\%81v.\+/

au BufRead,BufNewFile *.tex setlocal textwidth=80
au BufRead,BufNewFile *.md setlocal textwidth=80
au BufRead,BufNewFile *.txt setlocal textwidth=80

autocmd BufRead,BufNewFile *.tex setlocal spell
autocmd BufRead,BufNewFile *.md setlocal spell
autocmd BufRead,BufNewFile *.txt setlocal spell
autocmd FileType gitcommit setlocal spell
set complete+=kspell

" Automatic reloading of .vimrc
autocmd! bufwritepost .vimrc source %

" ================ Tabs/Buffers ==============
"
" 4 space tab.
filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab

" tab view in vim
map <leader>t :tabe<Space>
map <leader>tt :tabnew<CR>
"git shortcut to add all to staging area
" map <leader>gg :!git add . <CR>:!git commit<CR>
map <leader>b :bnext<CR>
map <leader>bp :bprev<CR>
map <leader>bf :bfirst<CR>
map <leader>bl :blast<CR>

map<leader>e :e<CR>

" ================ Splits ==============
"
map <leader>- :split<Space>
map <leader><Bar> :vsplit<Space>
map <leader>qw :close<CR>

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" ================ Vimdiff Splits ==============
"
map <leader>wqa :wqa
map <leader>qa :qa
map <leader>qaa :qa!

" ================ R Batch Mode ==============
"
map <leader>rr :w<CR>:!R CMD BATCH %<CR>

" ================ LaTeX ==============
"
map <leader>lc :!latex <C-R>%<CR>
map <leader>pc :!pdflatex <C-R>%<CR>
map <leader>po :!open <C-R>%<BS><BS><BS><BS>.pdf<CR>
map <leader>lm :w<CR>:!latex <C-R>%<CR><CR>:!pdflatex <C-R>%<CR><CR>:!open <C-R>%<BS><BS><BS><BS>.pdf<CR><CR>
map <leader>mint :w<CR>:!latex --shell-escape <C-R>%<CR><CR>:!pdflatex --shell-escape <C-R>%<CR><CR>:!open <C-R>%<BS><BS><BS><BS>.pdf<CR>
map <leader>wc :!texcount <C-R>%<CR>

" ================ Pandoc ==============
"
map <leader>pan :!pandoc <C-R>% --latex-engine=xelatex -o <C-R>%<BS><BS><BS>.pdf<CR><CR>:!open <C-R>%<BS><BS><BS>.pdf<CR>
map <leader>panc :!pandoc <C-R>% --latex-engine=xelatex --toc -o <C-R>%<BS><BS><BS>.pdf<CR><CR>:!open <C-R>%<BS><BS><BS>.pdf<CR>
map <leader>pans :!pandoc <C-R>% --latex-engine=xelatex --toc -o -s <C-R>%<BS><BS><BS>.pdf<CR><CR>:!open <C-R>%<BS><BS><BS>.pdf<CR>

" ================ Jython JSyn Build ==============
"
map <leader>jyr :w<CR>:!jython -J-classpath ~/jars/*.jar <C-R>%<CR>
"map <leader>jj :w<CR>:!jython -J-classpath ~/jars/*.jar <C-R>%<CR>
"map <leader>jj :w<CR>:!jython -J-classpath ~/jMusic/*.jar <C-R>%<CR>
map <leader>jj :w<CR>:!sh jython.sh <C-R>%<CR>
" Java compile and run shortcuts
map <leader>jr :w<CR>:!javac <C-R>%<CR>:!java <C-R>%<BS><BS><BS><BS><BS>

" ================ Write/Save/Quit ==============
"
" write, write-quit, quit-force shortcuts
map <leader>w :w<CR>
map <leader><Space> :w<CR>
map <leader>wq :wq<CR>
map <leader>qq :q!<CR>
map <leader>q :q<CR>

" ================ Compiling ==============
"
:autocmd FileType c nnoremap <buffer> <localleader>r :!gcc %<CR><CR>:!./a.out<CR>
:autocmd FileType fortran nnoremap <buffer> <localleader>r :!gfortran %<CR><CR>:!./a.out<CR>

"################################################
" ================ PLUGINS SECTION ==============
"################################################
" set the runtime path to include Vundle and initialize
set rtp+=$HOME/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
" run ':PluginInstall' to properly load vundle plguins
" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'tomasr/molokai'
Plugin 'scrooloose/nerdtree'
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/syntastic'
Plugin 'uguu-org/vim-matrix-screensaver'
Plugin 'vim-scripts/AutoComplPop'
Plugin 'honza/vim-snippets'             " Track the engine.
Plugin 'Yggdroot/indentLine'
Plugin 'vim-scripts/yavdb'              " Yet another debugger
Plugin 'raichoo/haskell-vim'            " Haskell help for Vim
Plugin 'jistr/vim-nerdtree-tabs'        " To allow just one NERDTree
Plugin 'bling/vim-airline'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-commentary'
Plugin 'mileszs/ack.vim'
" Plugin 'SirVer/ultisnips'
Plugin 'rstacruz/sparkup'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'tmhedberg/matchit'
Plugin 'ervandew/supertab'
Plugin 'sickill/vim-pasta'
Plugin 'jceb/vim-orgmode'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
" Plugin 'garbas/vim-snipmate'
Plugin 'vimwiki/vimwiki'
"
Plugin 'Shougo/neocomplete'
Plugin 'Shougo/neosnippet'
Plugin 'Shougo/neosnippet-snippets'
"
set rtp+=~/usr/local/Cellar/fzf/0.10.2
Plugin 'junegunn/fzf'
" ==============================================================================
" Plugins that are not used.
"Plugin 'kchmck/vim-coffee-script'
"Plugin 'tpope/vim-endwise'
"Plugin 'https://bitbucket.org/kink/kink.vim'
"needed for gist
"Plugin 'mattn/webapi-vim'
"Plugin 'mattn/gist-vim'
"Plugin 'tpope/vim-rails'
"Plugin 'Valloric/YouCompleteMe' -- trouble with python. fatal errors.
" Snippets are separated from the engine. Add this if you want them:
" ==============================================================================
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to
" auto-approve removal
"
" see :h vundle for more details or wiki for FAQ

" ================ Colour Scheme ==============
"
"For Vim solarized
syntax enable
let g:solarized_termcolors=256
set background=dark
"colorscheme solarized
colorscheme molokai

" ================ jistr/vim-nerdtree-tabs =============
"
map <Leader>f :FZF<CR>

" ================ jistr/vim-nerdtree-tabs =============
"
" NERDTree Shortcut
"map <leader>f :NERDTree<CR>
map <Leader>nn <plug>NERDTreeTabsToggle<CR>
:nmap ?? <Plug>NERDTreeTabsToggle<CR>

map <leader>n :NERDTreeFocusToggle<CR>
map <leader>nfind :NERDTreeTabsFind<CR>
let g:nerdtree_tabs_autoclose = 1   " Close current tab if there is only one window in it and it's NERDTree
let g:nerdtree_tabs_synchronize_view = 1    " Synchronize view of all NERDTree windows (scroll and cursor position)
let g:nerdtree_tabs_autofind = 0    " Automatically find and select currently opened file in NERDTree.
let g:nerdtree_tabs_meaningful_tab_names = 1    " Unfocus NERDTree when leaving a tab for descriptive tab names

" ================ 'scrooloose/syntastic' ==============
"
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0

" ================ 'SirVer/ultisnips' ==============
"
" Trigger configuration. Do not use <tab> if you use
" https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-d>"
let g:UltiSnipsJumpBackwardTrigger="<c-s>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" ================ 'Shougo/neosnippet.vim' ==============
"
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
    set conceallevel=2 concealcursor=niv
endif

" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1
" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory="~/.vim/bundle/vim-snippets/snippets, ~/.vim/bundle/my-snippets/"
map<leader>se :NeoSnippetEdit<CR>

" ================ 'vim-scripts/AutoComplPop' ==============
"
" Allows <Tab> to go through options in 'AutoComplPop'
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<C-g>u\<Tab>"

" ================ jistr/vim-nerdtree-tabs ==============
"
" for Haskell
let g:haskell_enable_quantification = 1 " to enable highlighting of forall
let g:haskell_enable_recursivedo = 1 " to enable highlighting of mdo and rec
let g:haskell_enable_arrowsyntax = 1 " to enable highlighting of proc
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of pattern
let g:haskell_enable_typeroles = 1 " to enable highlighting of type roles
let g:haskell_indent_if = 3
let g:haskell_indent_case = 2
let g:haskell_indent_let = 4
let g:haskell_indent_where = 6
let g:haskell_indent_do = 3
let g:haskell_indent_in = 1

" ================  vim/airline   ==============
"
" airline options
let g:airline_powerline_fonts=1
let g:airline_left_sep=''
let g:airline_right_sep=''
"let g:airline_theme='base16'

if !exists('g:airline_symbols')
      let g:airline_symbols = {}
  endif
  let g:airline_symbols.space = "\ua0"

set laststatus=2 " show the satus line all the time
let g:netrw_dirhistmax = 0
" enable/disable detection of whitespace errors. >
let g:airline#extensions#whitespace#enabled = 0
" customize the type of mixed indent checking to perform. >
" must be all spaces or all tabs before the first non-whitespace character
let g:airline#extensions#whitespace#mixed_indent_algo = 0
" certain number of spaces are allowed after tabs, but not in between
" this algorithm works well for /** */ style comments in a tab-indented file
let g:airline#extensions#whitespace#mixed_indent_algo = 1
" spaces are allowed after tabs, but not in between
" this algorithm works well with programming styles that use tabs for
" indentation and spaces for alignment
let g:airline#extensions#whitespace#mixed_indent_algo = 2
" customize the whitespace symbol. >
let g:airline#extensions#whitespace#symbol = '!'
" configure which whitespace checks to enable. >
let g:airline#extensions#whitespace#checks = [ 'indent', 'trailing' ]
" configure the maximum number of lines where whitespace checking is enabled. >
let g:airline#extensions#whitespace#max_lines = 20000
" configure whether a message should be displayed. >
let g:airline#extensions#whitespace#show_message = 0
" configure the formatting of the warning messages. >
let g:airline#extensions#whitespace#trailing_format = 'trailing[%s]'
let g:airline#extensions#whitespace#mixed_indent_format = 'mixed-indent[%s]'

" ================  'mileszs/ack.vim' ==============
"
map <leader>a :Ack<Space>
" let g:ackprg = $HOME/bin/ack -s -H --nocolor --nogroup --column

" ================  'ntpeters/vim-better-whitespace' ==============
"
autocmd BufWritePre * StripWhitespace
" map <leader>ws :StripWhitespace<CR>

" ++++++++++++++++++++++++++++++++++++++
" ================  EOF   ==============
" ++++++++++++++++++++++++++++++++++++++
