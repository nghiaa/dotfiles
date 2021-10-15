scriptencoding utf-8

let g:mapleader = ' '
set runtimepath+=~/.fzf

call plug#begin('~/.vim/plugged')

"[ File Explorer ]
Plug 'joshdick/onedark.vim', { 'branch': 'main' }
Plug 'preservim/nerdTree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

"[ Code Editing ]"
Plug 'dense-analysis/ale'
Plug 'tpope/vim-surround'
Plug 'AndrewRadev/splitjoin.vim'

"[ Status Bar ]
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

"[ Git ]
Plug 'tpope/vim-fugitive' 
Plug 'junegunn/gv.vim'

call plug#end()

" Required:
filetype plugin indent on
syntax enable

" ==============================================================================
" Settings

set backspace=indent,eol,start  " Allow backspacing over everything

set history=1000                " Store 1000 :cmdline history

set showcmd                     " Show imcomplete cmds down the bottom
set noshowmode                    " Show current mode at the bottom

if has('patch-7.4.314')
    set shortmess+=c
endif

set incsearch                   " Incremental searching
set hlsearch                    " Highlight searches by default

set nowrap                        " Don't wrap lines
"set linebreak                  " Wrap lines at convenient points

set number                      " Show linenumber
set ruler                       " Show current cursor position all the time

" Keep backup file
set backup
set backupdir =$HOME/.vimbackup

" default indent settings
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
set autoindent

" commands
command BD bp|bd #

augroup pythonConf
    au FileType python map <leader>\ :!python %
augroup END

set textwidth=72                 " Set textwidth
set formatoptions=cq
set wrapmargin=0

" Folding settings
set foldmethod=indent           " Fold based on indent
set foldnestmax=7               " Deepest fold is 7 level
set nofoldenable                " Don't fold by default

" Wildmode settings
set wildmode=list:longest,full       " Make cmdline tab completion similar to bash
set wildmenu                    " Make ^n & ^p to scroll through matches
set wildignore=*.o,*.obj,*~     " Stuff to ignore when tab completing

" Display tabs ans trailing spaces
set list
set listchars=tab:▷⋅,trail:⋅,nbsp:⋅

" Vertical/Horizontal scroll off settings
set scrolloff=3
set sidescrolloff=7
set sidescroll=1

" Turn on syntax highlighting
syntax on
set background=dark
colorscheme onedark
let g:airline_theme='onedark'

set mouse=a                     " Enable mouse

if !has('nvim')
    set ttymouse=xterm2             " Enable mouse even in screen
    set viminfo=%,'50,\"100,:100,n~/.viminfo
endif

set hidden                      " Allow vim to hide modified buffers

set ignorecase                  " Ignore case searching
set smartcase                   " Only ignore case when all text is lowercase

set grepprg=grep\ -nH\ $*

" ==============================================================================
" Functions ...

" Jump to last cursor pos when opening a file
" don't do it when writing a commit log entry
function! SetCursorPosition()
  if &filetype !~? 'commit\c'
    if line("'\"") > 0 && line("'\"") <= line('$')
      exe "normal! g`\""
      normal! zz
    endif
  endif
endfunction

" Visual search function
function! s:VSetSearch()
  let l:temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  let @@ = l:temp
endfunction

" ==============================================================================
" Autocmd to run when loading new buffer

" Jump to last cursor pos when opening a file
augroup reloadLastPos
    autocmd BufReadPost * call SetCursorPosition()
augroup END

" Map backspace to switch to previous buffer
nnoremap <BS> <C-^><CR>

" Map Q to sth useful
nnoremap Q gq

" Make Y consistent with C and D
nnoremap Y y$

" Map * and # to search selected text
vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR>

nnoremap <leader>ff :FZF<CR>
nnoremap <leader>fb :buffers<CR>
"nnoremap <leader>fw :Windows<CR>
nnoremap <leader><UP> <C-W>k
nnoremap <leader><DOWN> <C-W>j
nnoremap <leader><LEFT> <C-W>h
nnoremap <leader><RIGHT> <C-W>l
nnoremap <leader>w<UP> <C-W>K
nnoremap <leader>w<DOWN> <C-W>J
nnoremap <leader>w<LEFT> <C-W>H
nnoremap <leader>w<RIGHT> <C-W>L
nnoremap <leader><SPACE> :Commands<CR>

"imap <Leader>q <C-j>

" Ale configuration
let g:ale_sign_error = '⤫'
let g:ale_sign_warning = '⚠'
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" Airline configuration
" Status bar
let g:airline_theme='onedark' 										" Theme OneDark
let g:airline#extensions#tabline#enabled = 1 						" Enable Tab bar
let g:airline#extensions#tabline#left_sep = ' ' 					" Enable Tab seperator 
let g:airline#extensions#tabline#left_alt_sep = '|' 				" Enable Tab seperator
let g:airline#extensions#tabline#formatter = 'default'
let g:airline#extensions#tabline#fnamemod = ':t' 					" Set Tab name as file name
let g:airline#extensions#whitespace#enabled = 0  					" Remove warning whitespace"
let g:airline_detect_modified = 1
let g:airline_powerline_fonts = 1

" auto save when calling :make
set autowrite

nnoremap <leader>a :cclose<CR>:lclose<CR>
nnoremap <leader>A :cw<CR>:lw<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Other plug-in's settings 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" 
let vim_settings_dir = '~/.vim/settings/'

execute 'source '.vim_settings_dir.'nerdtree.vim'