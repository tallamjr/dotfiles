" ================ Leader-Key ===========================
"
let mapleader = ","
let maplocalleader = "\\"

" ================ Re-map Escape ===========================
"
" Map escape
:imap kj <Esc>

" ================ General Configuration ==============
"
set nocompatible     	 " We're running Vim, not Vi!
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
set cursorline
set shortmess-=S        "https://vi.stackexchange.com/a/23296/5525

map <leader>sub :%s

map <leader>fmt :!fmt -1000<CR>

map <leader>mm :!markmap -w % &<CR>

map <Leader>/ :set hlsearch! hlsearch?<CR>
map <localleader>com :highlight Comment ctermfg=LightGreen<CR>
" hi Comment ctermbg=0 ctermfg=LightBlue

nnoremap <Leader>l :set cursorline!<CR>
map <Leader>col :set colorcolumn=80<CR>
map <Leader>coll :set colorcolumn&<CR>

set foldlevel=99
set foldmethod=indent
nnoremap <space> za
vnoremap <space> zf

xnoremap <leader>say :w !say<CR>

" set shellcmdflag=-ic    "Run interactive shell for custom commands
"
fun! SetMyTodos()
  syn match myTodos /\%(DONE\)\|\%(NOTE:\)/ containedin=.*Comment
  hi link myTodos Todo
endfu
autocmd bufenter * :call SetMyTodos()
autocmd filetype * :call SetMyTodos()

" ================ NeoVim ==============
tnoremap kj <C-\><C-n>
tnoremap <Esc> <C-\><C-n>:bd!<CR>

let g:python3_host_prog = '/Users/tallamjr/mambaforge/envs/main/bin/python'

" ================ Persistant Undo ===========================
"
" Modern Vim pg 100
" if !has('nvim')
" Ref: https://vi.stackexchange.com/a/53/5525
if !isdirectory($HOME."/.vim/undo")
  call mkdir($HOME."/.vim/undo", "", 0700)
endif
set undofile
set undodir=~/.vim/undo
augroup vimrc
  autocmd!
  autocmd BufWritePre /tmp/* setlocal noundofile
augroup END

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

nmap <Leader>ic :set ignorecase! ignorecase?<CR>
" map <Leader>/ :noh<CR>
" nnoremap <C-h> :set hlsearch! hlsearch?<CR>
map <Leader>/ :set hlsearch! hlsearch?<CR>
map <Leader>wc :w !wc -w<CR>
xnoremap <leader>wcc :g <C-G>

" ================ Textwidth/Spellchecker ==============
"
" highlight when over 80 characters
"highlight Overlength ctermbg=red ctermfg=white
"match Overlength /\%81v.\+/

au BufRead,BufNewFile *.tex setlocal textwidth=80
au BufRead,BufNewFile *.md setlocal textwidth=80
au BufRead,BufNewFile *.txt setlocal textwidth=80
au BufRead,BufNewFile *.wiki setlocal textwidth=80
au BufRead,BufNewFile *.* setlocal textwidth=80

map <Leader>stw :set textwidth=

set spelllang=en_gb
set spellfile=$HOME/dotfiles/vim/spell/custom.en.utf-8.add

autocmd BufRead,BufNewFile *.tex setlocal spell
autocmd BufRead,BufNewFile *.vimwiki setlocal spell
autocmd BufRead,BufNewFile *.wiki setlocal spell
autocmd BufRead,BufNewFile *.md setlocal spell
autocmd BufRead,BufNewFile *.markdown setlocal spell
autocmd BufRead,BufNewFile *.txt setlocal spell
autocmd FileType gitcommit setlocal spell
set complete+=kspell

autocmd BufNewFile,BufRead *.gs set filetype=javascript

" Automatic reloading of .vimrc
autocmd! bufwritepost .vimrc source %
" Set files with extention of .md as markdown type.
au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown

" Set files with extention of .md as markdown type.
au BufNewFile,BufFilePre,BufRead *.conf set filetype=bash

au BufRead,BufNewFile *.sc set filetype=scala
au! Syntax scala source ~/.vim/syntax/scala.vim

au FileType python map <silent> <leader>b obreakpoint()<esc>
au FileType python map <silent> <leader>B Obreakpoint()<esc>

" ================ Tabs/Buffers ==============
"
" 4 space tab, inspired by Linux kernel development
" Modified from: https://stackoverflow.com/questions/1878974/redefine-tab-as-4-spaces
filetype plugin indent on
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set smarttab

" tab view in vim
map <leader>t :tabe<Space>
map <leader>tt :tabnew<CR>
"git shortcut to add all to staging area
" map <leader>gg :!git add . <CR>:!git commit<CR>
map <leader>n :bnext<CR>
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
map <leader>ck :<CR>:!cd && pwd

map <leader>lm :w<CR>
    \:!biber <C-R>%<BS><BS><BS><BS><CR><CR>
    \:!latexmk -pdflatex=lualatex -pdf -file-line-error -halt-on-error -interaction=nonstopmode -shell-escape <C-R>%<CR><CR>
    \:!open <C-R>%<BS><BS><BS><BS>.pdf<CR><CR>

map <leader>lmm :w<CR>
    \:!latex <C-R>%<CR><CR>
    \:!bibtex <C-R>%<BS><BS><BS><BS><CR><CR>
    \:!latex <C-R>%<CR><CR>
    \:!pdflatex <C-R>%<CR><CR>
    \:!open <C-R>%<BS><BS><BS><BS>.pdf<CR><CR>
" \:!mv <C-R>%<BS><BS><BS><BS>.pdf .. <CR><CR>

map <leader>lmb :w<CR>:!latex <C-R>%<CR><CR>:!bibtex <C-R>%<CR><CR>:!latex <C-R>%<CR><CR>:!latex <C-R>%<CR><CR>:!pdflatex <C-R>%<CR><CR>:!open <C-R>%<BS><BS><BS><BS>.pdf<CR><CR>

map <leader>mint :w<CR>:!latex --shell-escape <C-R>%<CR><CR>:!pdflatex --shell-escape <C-R>%<CR><CR>:!open <C-R>%<BS><BS><BS><BS>.pdf<CR><CR>

map <leader>twc :!texcount <C-R>%<CR>

" map <leader>llm :w<CR>:!cd .. && latex src/<C-R>%<CR><CR>:!cd .. && bibtex src/<C-R>%<BS><BS><BS><BS><CR><CR>:!cd .. && latex src/<C-R>%<CR><CR>:!cd .. && pdflatex src/<C-R>%<CR><CR>:!cd .. && open <C-R>%<BS><BS><BS><BS>.pdf<CR><CR>

let g:tex_flavor='latex'
let g:tex_conceal = ""
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
:autocmd FileType scala nnoremap <buffer> <localleader>r :!scalac -d classes <C-R>%<CR><CR>:!scala -cp classes <C-R>%<BS><BS><BS><CR>

:nmap cp :let @" = expand("%")
:autocmd FileType java nnoremap <buffer> <localleader>r :!javac %<CR><CR>:!java <C-R>%<BS><BS><BS><BS><BS><CR>

:autocmd FileType python nnoremap <buffer> <localleader>r :!python %<CR>
:autocmd FileType tex nnoremap <buffer> <localleader>c :!pdflatex %<CR><CR>:!open <C-R>%<BS><BS><BS><BS>.pdf<CR><CR>

" ================ Working Directory ==============
"
" Get the working directory and pipe in pbcopy, which is a mac specific program
" that holds things to the system clipboard. CTRL-V to paste the aquired
" contents or can use another mac specific program at the command line; pbpaste
map <leader>pwd :!echo $PWD <Bar> pbcopy<CR><CR>
"
" ================ Abbreviations ==============
source ~/dotfiles/vim/abbreviations.vim
"
"################################################
" ================ PLUGINS SECTION ==============
"################################################
" Automatic Installation
" https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
set rtp +=~/.vim
call plug#begin('~/.vim/plugged')

Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/neosnippet.vim'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets' " Multiple Plug commands can be written in a single line using | separators
Plug 'Yggdroot/indentLine'
Plug 'altercation/vim-colors-solarized'
Plug 'beloglazov/vim-online-thesaurus'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'chrisbra/unicode.vim'
Plug 'ervandew/supertab'
Plug 'fatih/vim-go', { 'tag': '*' } " Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
Plug 'fisadev/vim-isort'
Plug 'flazz/vim-colorschemes'
Plug 'gmarik/Vundle.vim'
Plug 'godlygeek/tabular'
Plug 'https://github.com/junegunn/vim-github-dashboard.git' " Any valid git URL is allowed
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'itchyny/calendar.vim'
Plug 'jceb/vim-orgmode'
Plug 'jistr/vim-nerdtree-tabs' " To allow just one NERDTree
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/vim-easy-align' " Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'kien/ctrlp.vim'
" Plug 'neoclide/coc.nvim', {'branch': 'release'} " Use release branch (recommend)
Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' } " Plugin options
Plug 'ntpeters/vim-better-whitespace'
Plug 'nvie/vim-flake8'
Plug 'pbrisbin/vim-colors-off'
Plug 'plasticboy/vim-markdown'
Plug 'psf/black', { 'tag': '24.2.0' }
Plug 'raichoo/haskell-vim' " Haskell help for Vim
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' } " Using a non-default branch
Plug 'rking/ag.vim'
Plug 'ron89/thesaurus_query.vim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'rstacruz/sparkup'
Plug 'rust-lang/rust.vim'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' } " On-demand loading
Plug 'sickill/vim-pasta'
Plug 'stephpy/vim-yaml'
Plug 'tmhedberg/matchit'
Plug 'tomasr/molokai'
Plug 'tomtom/tlib_vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'uguu-org/vim-matrix-screensaver'
Plug 'vim-scripts/AutoComplPop'
Plug 'vim-scripts/yavdb' " Yet another debugger
Plug 'vim-syntastic/syntastic'
Plug 'vimwiki/vimwiki'
set rtp+=~/usr/local/opt/fzf
" All of your Plugins must be added before the following line
" Initialize plugin system
call plug#end()
"
filetype plugin indent on    " required
"
" ================ Colour Scheme ==============
"
"For Vim colorscheme
syntax enable
let g:solarized_termcolors=256
set background=dark
" colorscheme solarized
set t_Co=256
if !exists('g:not_finish_vimplug')
  colorscheme molokai
endif
highlight SpecialComment  ctermfg=245   cterm=bold
highlight Comment  ctermfg=242   cterm=bold
au BufRead,BufNewFile *.py highlight Comment ctermfg=darkgrey
au BufRead,BufNewFile *.bib highlight Comment ctermfg=green

hi SpellBad cterm=bold ctermfg=yellow
au FileType vimwiki highlight SpellBad cterm=bold ctermfg=white
" ================ Python =======================
"
autocmd BufWritePre *.py Isort
map <Leader>r :FZF<CR>

" ================ YAML Formatting ==============
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
au FileType yaml let &l:formatprg= "yamlfmt /dev/stdin"

" ================ 'Shougo/neosnippet.vim' ==============
"
" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <expr><TAB>
 \ pumvisible() ? "\<C-n>" :
 \ neosnippet#expandable_or_jumpable() ?
 \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=0 concealcursor=niv
endif

" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1

" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/dotfiles/vim/my-snippets'

map<leader>snip :NeoSnippetEdit<CR>

" ================ COCsnippets ==============
"
" Use <C-l> for trigger snippet expand.
" imap <C-l> <Plug>(coc-snippets-expand)

" " Use <C-j> for select text for visual placeholder of snippet.
" vmap <C-j> <Plug>(coc-snippets-select)

" " Use <C-j> for jump to next placeholder, it's default of coc.nvim
" let g:coc_snippet_next = '<c-j>'

" " Use <C-k> for jump to previous placeholder, it's default of coc.nvim
" let g:coc_snippet_prev = '<c-k>'

" " Use <C-j> for both expand and jump (make expand higher priority.)
" imap <C-j> <Plug>(coc-snippets-expand-jump)

" " Use <leader>x for convert visual selected code to snippet
" xmap <leader>x  <Plug>(coc-convert-snippet)

" inoremap <silent><expr> <C-l>
"       \ coc#pum#visible() ? coc#_select_confirm() :
"       \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
"       \ CheckBackSpace() ? "\<TAB>" :
"       \ coc#refresh()

" function! CheckBackSpace() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~# '\s'
" endfunction

" let g:coc_snippet_next = '<tab>'

" ================ 'nvie/vim-flake8' =============
"
let g:flake8_cmd = "/Users/tallamjr/mambaforge/envs/astronet/bin/flake8"

" ================ 'psf/black' =============
"
" Black(Python) format the visual selection
xnoremap <Leader>k :!black -q -<CR>
map <Leader>kk :Black<CR>
" autocmd BufWritePre *.py Black
" let g:black_virtualenv="/Users/tallamjr/miniforge3/envs/main/bin"

" ================ 'neoclide/coc.nvim' =============
"
" use <c-space>for trigger completion
inoremap <silent><expr> <c-space> coc#refresh()
" Use <C-@> on vim
inoremap <silent><expr> <c-@> coc#refresh()

inoremap <expr> <S-Tab> coc#pum#visible() ? coc#pum#next(1) : "\<S-Tab>"
inoremap <expr> <Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<Tab>"

set completeopt=menu,menuone,noselect

" ================ 'junegunn/fzf' =============
"
map <Leader>f :FZF<CR>

" ================ 'Yggdroot/indentLine' =============
"
map <localleader>show :set conceallevel=0<CR>

let g:indentLine_setConceal = 0
" ================ 'plasticboy/vim-markdown' =============
"
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_math = 1
let g:vim_markdown_frontmatter = 1

" ================ 'rust-lang/rust.vim' =============
" Visual mode
map <leader>rft :!rustfmt<CR>
" On full file
map <localleader>rft :RustFmt<CR>
" Placing let g:rustfmt_autosave = 1 in your ~/.vimrc will enable automatic running of :RustFmt when
" you save a buffer.
let g:rustfmt_autosave = 1

" ================ 'jistr/vim-nerdtree-tabs' =============
"
" NERDTree Shortcut
map <leader>ntree :NERDTree<CR>
map <Leader>nn <plug>NERDTreeTabsToggle<CR>
:nmap ?? <Plug>NERDTreeTabsToggle<CR>

map <leader>nt :NERDTreeFocusToggle<CR>
map <leader>nfind :NERDTreeTabsFind<CR>

nmap <Leader>R :NERDTreeFocus<CR>R<C-W><C-P>
let g:nerdtree_tabs_autoclose = 1   " Close current tab if there is only one window in it and it's NERDTree
let g:nerdtree_tabs_synchronize_view = 1    " Synchronize view of all NERDTree windows (scroll and cursor position)
let g:nerdtree_tabs_autofind = 0    " Automatically find and select currently opened file in NERDTree.
let g:nerdtree_tabs_meaningful_tab_names = 1    " Unfocus NERDTree when leaving a tab for descriptive tab names
" let NERDTreeMapOpenInTab='<ENTER>'

" ================ 'scrooloose/syntastic' ==============
"
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_python_flake8_post_args='--ignore=E501,E203'

" ================ 'SirVer/ultisnips' ==============
"
" Trigger configuration. Do not use <tab> if you use
" https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-n>"
let g:UltiSnipsJumpForwardTrigger="<c-d>"
let g:UltiSnipsJumpBackwardTrigger="<c-s>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" ================ 'vim/airline'  ==============
"
let g:airline_theme='deus'
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
" enable/disable word counting of the document/visual selection >
let g:airline#extensions#wordcount#enabled = 1
" set list of filetypes for which word counting is enabled:
" The default value matches filetypes typically used for documentation
" such as markdown and help files. Default is:
let g:airline#extensions#wordcount#filetypes = ['asciidoc', 'help', 'vimwiki', 'markdown', 'org', 'rst', 'tex', 'text']
" ================ 'mileszs/ack.vim' ==============
"
" map <leader>a :Ack<Space>
" let g:ackprg = $HOME/bin/ack -s -H --nocolor --nogroup --column

" ================ 'rking/ag.vim' ==============
"
map <leader>a :Ag<Space>
map <leader>aa :AgFromSearch<CR>

" ================ 'easy-align'
"
" Align GitHub-flavored Markdown tables
au FileType * vmap <Leader><Bslash> :EasyAlign*<Bar><Enter>
" au FileType vimwiki vmap <Leader><Bslash> :EasyAlign*<Bar><Enter>
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" ================ 'ntpeters/vim-better-whitespace' ==============
"
autocmd BufWritePre * StripWhitespace
" map <leader>ws :StripWhitespace<CR>
let g:current_line_whitespace_disabled_hard=1

" ================ 'vimwiki/vimwiki' ==============
"
let g:vimwiki_global_ext = 0
let g:vimwiki_use_calendar = 1
" Plugin 'itchyny/calendar.vim' within vimwiki
let g:calendar_google_calendar = 1
let g:calendar_google_task = 1

" To use Markdown's wiki markup: >
" let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]
" vimwiki with markdown support
" let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown','.mdown': 'markdown'}
" helppage -> :h vimwiki-syntax
let g:vimwiki_hl_headers = 1

source ~/vimwiki/wiki.vim

map <leader>iu :VimwikiDiaryGenerateLinks<CR>
map <localleader>re :VimwikiAll2HTML<CR> :!open ~/vimwiki_html/index.html<CR>
map <leader>ui :VimwikiUISelect<CR>
map <leader>ft :setl filetype=

" From docs; *VimwikiLinkHandler*
" A customizable link handler can be defined to override Vimwiki's behavior when
" opening links.
"
" A example which handles a new scheme, 'vfile:', which behaves similar to
" 'file:', but the files are always opened with Vim in a new tab:
function! VimwikiLinkHandler(link)
  " Use Vim to open external files with the 'vfile:' scheme.  E.g.:
  "   1) [[vfile:~/Code/PythonProject/abc123.py]]
  "   2) [[vfile:./|Wiki Home]]
  let link = a:link
  if link =~# '^vfile:'
    let link = link[1:]
  else
    return 0
  endif
  let link_infos = vimwiki#base#resolve_link(link)
  if link_infos.filename == ''
    echomsg 'Vimwiki Error: Unable to resolve link!'
    return 0
  else
    exe 'tabnew ' . fnameescape(link_infos.filename)
    return 1
  endif
endfunction

" let g:vimwiki_list = [{'path': '~/PhD/wiki',
"   \ 'path_html': '~/PhD/wiki/html',
"   \ 'syntax': 'markdown',
"   \ 'ext': '.markdown',
"   \ 'custom_wiki2html': '~/scripts/wiki2html.sh'}]

" Set vimwiki syntax highlighting to follow markdown style
" au FileType vimwiki set syntax=pandoc
:autocmd FileType vimwiki nnoremap <buffer> <localleader>d :VimwikiMakeDiaryNote<CR>

function! ToggleCalendar()
  execute ":Calendar"
  if exists("g:calendar_open")
    if g:calendar_open == 1
      execute "q"
      unlet g:calendar_open
    else
      g:calendar_open = 1
    end
  else
    let g:calendar_open = 1
  end
endfunction
:autocmd FileType vimwiki nnoremap <buffer> <localleader>c :call ToggleCalendar()<CR>

" ================ 'iamcco/markdown-preview.nvim' ==============
" Start the preview
map <leader>md :MarkdownPreview<CR>

" Stop the preview"
map <leader>mdd :MarkdownPreviewStop<CR>

" set to 1, nvim will open the preview window after entering the markdown buffer
" default: 0
let g:mkdp_auto_start = 0

" set to 1, the nvim will auto close current preview window when change
" from markdown buffer to another buffer
" default: 1
let g:mkdp_auto_close = 1

" set to 1, the vim will refresh markdown when save the buffer or
" leave from insert mode, default 0 is auto refresh markdown as you edit or
" move the cursor
" default: 0
let g:mkdp_refresh_slow = 0

" set to 1, the MarkdownPreview command can be use for all files,
" by default it can be use in markdown file
" default: 0
let g:mkdp_command_for_global = 0

" set to 1, preview server available to others in your network
" by default, the server listens on localhost (127.0.0.1)
" default: 0
let g:mkdp_open_to_the_world = 1

" use custom IP to open preview page
" useful when you work in remote vim and preview on local browser
" more detail see: https://github.com/iamcco/markdown-preview.nvim/pull/9
" default empty
" let g:mkdp_open_ip = ''

" specify browser to open preview page
" default: ''
" let g:mkdp_browser = ''

" set to 1, echo preview page url in command line when open preview page
" default is 0
" let g:mkdp_echo_preview_url = 0

" a custom vim function name to open preview page
" this function will receive url as param
" default is empty
" let g:mkdp_browserfunc = ''

" options for markdown render
" mkit: markdown-it options for render
" katex: katex options for math
" uml: markdown-it-plantuml options
" maid: mermaid options
" disable_sync_scroll: if disable sync scroll, default 0
" sync_scroll_type: 'middle', 'top' or 'relative', default value is 'middle'
"   middle: mean the cursor position alway show at the middle of the preview page
"   top: mean the vim top viewport alway show at the top of the preview page
"   relative: mean the cursor position alway show at the relative positon of the preview page
" hide_yaml_meta: if hide yaml metadata, default is 1
" sequence_diagrams: js-sequence-diagrams options
" content_editable: if enable content editable for preview page, default: v:false
" disable_filename: if disable filename header for preview page, default: 0
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {},
    \ 'flowchart_diagrams': {},
    \ 'content_editable': v:false,
    \ 'disable_filename': 0
    \ }

" use a custom markdown style must be absolute path
" like '/Users/username/markdown.css' or expand('~/markdown.css')
let g:mkdp_markdown_css = ''

" use a custom highlight style must absolute path
" like '/Users/username/highlight.css' or expand('~/highlight.css')
let g:mkdp_highlight_css = ''

" use a custom port to start server or random for empty
" let g:mkdp_port = ''

" preview page title
" ${name} will be replace with the file name
let g:mkdp_page_title = '[${name}]'

" recognized filetypes
" these filetypes will have MarkdownPreview... commands
let g:mkdp_filetypes = ['markdown']

" ================ 'Ron89/thesaurus_query.vim' =============
nnoremap <Leader>s :ThesaurusQueryReplaceCurrentWord<CR>
nnoremap <Leader>ss :Thesaurus

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
" ++++++++++++++++++++++++++++++++++++===========  EOF   ==========================================
" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
