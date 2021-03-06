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
set cursorline

map <localleader>com :highlight Comment ctermfg=Grey<CR>

nnoremap <Leader>l :set cursorline!<CR>
map <Leader>col :set colorcolumn=80<CR>
map <Leader>coll :set colorcolumn&<CR>

set foldlevel=99
set foldmethod=indent
nnoremap <space> za
vnoremap <space> zf

" ================ Persistant Undo ===========================
"
" Modern Vim pg 100
set undofile
if !has('nvim')
  set undodir=~/.vim/undo
endif
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
au BufRead,BufNewFile *.* setlocal textwidth=100

set spelllang=en_gb
set spellfile=$HOME/Dropbox/vim/spell/custom.en.utf-8.add

autocmd BufRead,BufNewFile *.tex setlocal spell
autocmd BufRead,BufNewFile *.vimwiki setlocal spell
autocmd BufRead,BufNewFile *.wiki setlocal spell
autocmd BufRead,BufNewFile *.md setlocal spell
autocmd BufRead,BufNewFile *.markdown setlocal spell
autocmd BufRead,BufNewFile *.txt setlocal spell
autocmd FileType gitcommit setlocal spell
set complete+=kspell

" Automatic reloading of .vimrc
autocmd! bufwritepost .vimrc source %
" Set files with extention of .md as markdown type.
au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown

au BufRead,BufNewFile *.sc set filetype=scala
au! Syntax scala source ~/.vim/syntax/scala.vim
" ================ Tabs/Buffers ==============
"
" 4 space tab, inspired by Linux kernel development
" Modified from: https://stackoverflow.com/questions/1878974/redefine-tab-as-4-spaces
filetype plugin indent on
set tabstop=4
set softtabstop=4
set shiftwidth=4
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
map <leader>lm :w<CR>:!latex <C-R>%<CR><CR>:!bibtex <C-R>%<BS><BS><BS><BS><CR><CR>:!latex <C-R>%<CR><CR>:!pdflatex <C-R>%<CR><CR>:!open <C-R>%<BS><BS><BS><BS>.pdf<CR><CR>
map <leader>lmm :w<CR>:!latex <C-R>%<CR><CR>:!bibtex <C-R>%<BS><BS><BS><BS><CR><CR>:!latex <C-R>%<CR><CR>:!pdflatex <C-R>%<CR><CR>:!mv <C-R>%<BS><BS><BS><BS>.pdf .. <CR><CR>:!open ../<C-R>%<BS><BS><BS><BS>.pdf<CR><CR>

map <leader>lmb :w<CR>:!latex <C-R>%<CR><CR>:!bibtex <C-R>%<CR><CR>:!latex <C-R>%<CR><CR>:!latex <C-R>%<CR><CR>:!pdflatex <C-R>%<CR><CR>:!open <C-R>%<BS><BS><BS><BS>.pdf<CR><CR>
map <leader>mint :w<CR>:!latex --shell-escape <C-R>%<CR><CR>:!pdflatex --shell-escape <C-R>%<CR><CR>:!open <C-R>%<BS><BS><BS><BS>.pdf<CR><CR>
map <leader>twc :!texcount <C-R>%<CR>

" map <leader>llm :w<CR>:!cd .. && latex src/<C-R>%<CR><CR>:!cd .. && bibtex src/<C-R>%<BS><BS><BS><BS><CR><CR>:!cd .. && latex src/<C-R>%<CR><CR>:!cd .. && pdflatex src/<C-R>%<CR><CR>:!cd .. && open <C-R>%<BS><BS><BS><BS>.pdf<CR><CR>
map <leader>ck :<CR>:!cd && pwd

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

" ================ Working Directory ==============
"
" Get the working directory and pipe in pbcopy, which is a mac specific program
" that holds things to the system clipboard. CTRL-V to paste the aquired
" contents or can use another mac specific program at the command line; pbpaste
map <leader>pwd :!echo $PWD <Bar> pbcopy<CR><CR>

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
Plugin 'tpope/vim-obsession'
" Plugin 'mileszs/ack.vim'
Plugin 'rking/ag.vim'
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
" Plugin 'mattn/calendar-vim'
Plugin 'suan/vim-instant-markdown'
Plugin 'pbrisbin/vim-colors-off'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'beloglazov/vim-online-thesaurus'
Plugin 'itchyny/calendar.vim'
Plugin 'nvie/vim-flake8'
Plugin 'flazz/vim-colorschemes'
Plugin 'fsharp/vim-fsharp', {
      \ 'for': 'fsharp',
      \ 'do':  'make fsautocomplete',
      \}"
" Plugin 'python-mode/python-mode', { 'branch': 'develop' }
" A Vim Plugin for Lively Previewing LaTeX PDF Output
Plugin 'xuhdev/vim-latex-live-preview'"
set rtp+=~/usr/local/opt/fzf
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
"For Vim colorscheme
syntax enable
let g:solarized_termcolors=256
set background=dark
" colorscheme solarized
colorscheme molokai
au BufRead,BufNewFile *.py highlight Comment ctermfg=darkgrey
au BufRead,BufNewFile *.bib highlight Comment ctermfg=green

" ================ 'junegunn/fzf' =============
"
map <Leader>f :FZF<CR>

" ================ 'plasticboy/vim-markdown' =============
"
let g:vim_markdown_conceal = 0
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_math = 1
let g:vim_markdown_frontmatter = 1

" ================ 'jistr/vim-nerdtree-tabs' =============
"
" NERDTree Shortcut
"map <leader>f :NERDTree<CR>
map <Leader>nn <plug>NERDTreeTabsToggle<CR>
:nmap ?? <Plug>NERDTreeTabsToggle<CR>

map <leader>nt :NERDTreeFocusToggle<CR>
map <leader>nfind :NERDTreeTabsFind<CR>
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
let g:syntastic_python_flake8_post_args='--ignore=E501'

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
map<leader>snip :NeoSnippetEdit<CR>

" ================ 'vim-scripts/AutoComplPop' ==============
"
" Allows <Tab> to go through options in 'AutoComplPop'
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<C-g>u\<Tab>"

" ================ 'raichoo/haskell-vim' ==============
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
"
" ================ 'Shougo/neocomplete'  ==============
"
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
" ================ 'vim/airline'  ==============
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

" ================ 'ntpeters/vim-better-whitespace' ==============
"
autocmd BufWritePre * StripWhitespace
" map <leader>ws :StripWhitespace<CR>

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

let wiki_1 = {}
let wiki_1.path = '~/vimwiki/'
" let wiki_1.syntax = 'markdown'
" let wiki_1.ext = '.md'
" let wiki_1.ext2syntax = {'.md': 'markdown', '.markdown': 'markdown','.mdown': 'markdown'}
let wiki_1.nested_syntaxes = {'python': 'python', 'c++': 'cpp'}

let wiki_2 = {}
let wiki_2.path = '~/PhD/wiki/'
let wiki_2.index = 'index'
let wiki_2.syntax = 'markdown'
let wiki_2.ext = '.markdown'
let wiki_2.ext2syntax = {'.md': 'markdown', '.markdown': 'markdown','.mdown': 'markdown'}
let wiki_2.nested_syntaxes = {'python': 'python', 'c++': 'cpp'}

let wiki_3 = {}
let wiki_3.path = '~/PhD/cdt/placement/wiki/'
let wiki_3.index = 'index'
let wiki_3.syntax = 'markdown'
let wiki_3.ext = '.markdown'
let wiki_3.ext2syntax = {'.md': 'markdown', '.markdown': 'markdown','.mdown': 'markdown'}
let wiki_3.nested_syntaxes = {'python': 'python', 'c++': 'cpp'}

let wiki_4 = {}
let wiki_4.path = '~/Life/life/'
let wiki_4.index = 'README'
let wiki_4.syntax = 'markdown'
let wiki_4.ext = '.md'
let wiki_4.ext2syntax = {'.md': 'markdown', '.markdown': 'markdown','.mdown': 'markdown'}
let wiki_4.nested_syntaxes = {'python': 'python', 'c++': 'cpp'}

let wiki_5 = {}
let wiki_5.path = '~/Life/life/learn/'
let wiki_5.index = 'README'
let wiki_5.syntax = 'markdown'
let wiki_5.ext = '.md'
let wiki_5.ext2syntax = {'.md': 'markdown', '.markdown': 'markdown','.mdown': 'markdown'}
let wiki_5.nested_syntaxes = {'python': 'python', 'c++': 'cpp'}
"
let g:vimwiki_list = [wiki_1, wiki_2, wiki_3, wiki_4, wiki_5]

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
" ================ 'suan/vim-instant-markdown' ==============
"
" vim-instant-markdown - Instant Markdown previews from Vim
" https://github.com/suan/vim-instant-markdown
let g:instant_markdown_autostart = 0    " disable autostart
map <leader>md :InstantMarkdownPreview<CR>

let g:livepreview_previewer = 'open -a Preview'

" ================== 'fsharp/vim-fsharp' =====================

let g:fsharp_only_check_errors_on_write = 1
" ++++++++++++++++++++++++++++++++++++++
" ================  EOF   ==============
" ++++++++++++++++++++++++++++++++++++++
