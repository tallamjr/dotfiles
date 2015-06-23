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
set history=200

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
" run ':PluginInstall' to properly load vundle plguins
" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
  
Plugin 'tomasr/molokai'
   
Plugin 'scrooloose/nerdtree'
    
Plugin 'kien/ctrlp.vim' 

Plugin 'scrooloose/syntastic'

Plugin 'uguu-org/vim-matrix-screensaver'

Plugin 'vim-scripts/AutoComplPop' 
" Track the engine. 
Plugin 'SirVer/ultisnips'
" Snippets are separated from the engine. Add this if you want them:
Plugin 'honza/vim-snippets'

Plugin 'Yggdroot/indentLine'
" Yet another debugger"
Plugin 'vim-scripts/yavdb'
" Haskell help for Vim
Plugin 'raichoo/haskell-vim'
" To allow just one NERDTree
Plugin 'jistr/vim-nerdtree-tabs'
"Plugin 'Valloric/YouCompleteMe' ---- Requires later version of Vim.
" ==============================================================================
" Plugins that are not used.
"Plugin 'kchmck/vim-coffee-script'      
"Plugin 'tpope/vim-endwise'
"Plugin 'rstacruz/sparkup'
"Plugin 'https://bitbucket.org/kink/kink.vim'
"needed for gist
"Plugin 'mattn/webapi-vim'         
"Plugin 'mattn/gist-vim'          
"Plugin 'tpope/vim-rails'

" ==============================================================================

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" ==============================================================================
"For Vim solarized
syntax enable
"let g:solarized_termcolors=256
"set background=dark
"colorscheme solarized
"#############################
colorscheme molokai
             
"display line numbers on the left
set number


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   
"   Map leader shortcuts 
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Map escape 
:imap df <Esc>
let mapleader = ","

map <leader>rr :w<CR>:!R CMD BATCH %<CR>
" NERDTree Shortcut
"map <leader>f :NERDTree<CR>
map <Leader>ff <plug>NERDTreeTabsToggle<CR>
:nmap ?? <Plug>NERDTreeTabsToggle<CR>

map <leader>f :NERDTreeFocusToggle<CR>

map <leader>- :split<Space>
map <leader><Bar> :vsplit<Space>
map <leader>qw :close<CR>

map <leader>nfind :NERDTreeTabsFind<CR>
let g:nerdtree_tabs_autoclose = 1   " Close current tab if there is only one window in it and it's NERDTree
let g:nerdtree_tabs_synchronize_view = 1    " Synchronize view of all NERDTree windows (scroll and cursor position)
let g:nerdtree_tabs_autofind = 0    " Automatically find and select currently opened file in NERDTree.
let g:nerdtree_tabs_meaningful_tab_names = 1    " Unfocus NERDTree when leaving a tab for descriptive tab names

" Syntastic settings

"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0

" Trigger configuration. Do not use <tab> if you use
" https://github.com/Valloric/YouCompleteMe.
"let g:UltiSnipsExpandTrigger="<tab>"
"let g:UltiSnipsJumpForwardTrigger="<c-d>"
"let g:UltiSnipsJumpBackwardTrigger="<c-s>"

" If you want :UltiSnipsEdit to split your window.
"let g:UltiSnipsEditSplit="vertical"

" Allows <Tab> to go through options in 'AutoComplPop'
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<C-g>u\<Tab>"
" Latex shortcuts. 
map <leader>lc :!latex <C-R>%<CR>
map <leader>pc :!pdflatex <C-R>%<CR>
map <leader>po :!open <C-R>%<BS><BS><BS><BS>.pdf<CR>
map <leader>lm :w<CR>:!latex <C-R>%<CR><CR>:!pdflatex <C-R>%<CR><CR>:!open <C-R>%<BS><BS><BS><BS>.pdf<CR> 
map <leader>mint :w<CR>:!latex --shell-escape <C-R>%<CR><CR>:!pdflatex --shell-escape <C-R>%<CR><CR>:!open <C-R>%<BS><BS><BS><BS>.pdf<CR> 
map <leader>wc :!texcount <C-R>%<CR>
" Jython JSyn build shortcuts
map <leader>jyr :w<CR>:!jython -J-classpath ~/jars/*.jar <C-R>%<CR>
"map <leader>jj :w<CR>:!jython -J-classpath ~/jars/*.jar <C-R>%<CR>
"map <leader>jj :w<CR>:!jython -J-classpath ~/jMusic/*.jar <C-R>%<CR>
map <leader>jj :w<CR>:!sh jython.sh <C-R>%<CR>
" Java compile and run shortcuts
map <leader>jr :w<CR>:!javac <C-R>%<CR>:!java <C-R>%<BS><BS><BS><BS><BS>  
" Plays .wav file
map <leader>pl :!afplay<Space>  
" write, write-quit, quit-force shortcuts
map <leader>w :w<CR>
map <leader>wq :wq<CR>
map <leader>qq :q!<CR>
" tab view in vim
map <leader>t :tabe<Space>
map <leader>tt :tabnew<CR>
"git shortcut to add all to staging area
" map <leader>gg :!git add . <CR>:!git commit<CR>
map <leader>b :bnext<CR>
map <leader>bp :bprev<CR>
map <leader>bf :bfirst<CR>
map <leader>bl :blast<CR>

map <leader>gg :!git add <C-R>%<CR>:!git status<CR>
map <leader>gc :!git commit -m "


" highlight when over 80 characters
"highlight Overlength ctermbg=red ctermfg=white
"match Overlength /\%81v.\+/

au BufRead,BufNewFile *.tex setlocal textwidth=80

autocmd BufRead,BufNewFile *.tex setlocal spell
autocmd BufRead,BufNewFile *.txt setlocal spell
autocmd FileType gitcommit setlocal spell
set complete+=kspell

" Automatic reloading of .vimrc
autocmd! bufwritepost .vimrc source %

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to
" auto-approve removal
"
" see :h vundle for more details or wiki for FAQ

" 4 space tab.
filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab

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

noremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

set incsearch
set hlsearch
