set nocompatible     	 " We're running Vim, not Vi!
set term=screen-256color
syntax on             	" Enable syntax highlighting
filetype on           	" Enable filetype detection
filetype indent on    	" Enable filetype-specific indenting
filetype plugin on    	" Enable filetype-specific plugins
 
 
 
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
     
Plugin 'kchmck/vim-coffee-script'
      
Plugin 'tpope/vim-endwise'
       
Plugin 'rstacruz/sparkup'
        
Plugin 'https://bitbucket.org/kink/kink.vim'
         
Plugin 'vim-scripts/AutoComplPop' 
"needed for gist
Plugin 'mattn/webapi-vim'
          
Plugin 'mattn/gist-vim'
           
Plugin 'tpope/vim-rails'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
            
"For Vim solarized
syntax enable
"let g:solarized_termcolors=256
"set background=dark
"colorscheme solarized
"#############################
colorscheme molokai
             
"display line numbers on the left
set number

" Map escape 
:imap ;; <Esc>

let mapleader = ","
map <leader>lc :!latex <C-R>%<CR>
map <leader>pc :!pdflatex <C-R>%<CR>
map <leader>po :!open <C-R>%<BS><BS><BS><BS>.pdf<CR>
map <leader>w :w<CR>
map <leader>wq :wq<CR>

" highlight when over 80 characters in latexx
highlight Overlength ctermbg=red ctermfg=white
match Overlength /\%81v.\+/

au BufRead,BufNewFile *.tex setlocal textwidth=80

" autocmd BufRead,BufNewFile *.tex setlocal spell
autocmd FileType gitcommit setlocal spell
set complete+=kspell
