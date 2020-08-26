if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'SirVer/ultisnips' 
Plug 'honza/vim-snippets'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'airblade/vim-gitgutter'
Plug 'ervandew/supertab'
Plug 'scrooloose/syntastic'
Plug 'Raimondi/delimitMate'
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree'
Plug 'jremmen/vim-ripgrep'
Plug 'psf/black'
Plug 'zah/nim.vim'
Plug 'keith/swift.vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'Chiel92/vim-autoformat'
Plug 'neovimhaskell/haskell-vim'
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

"" themes
Plug '844196/lightline-badwolf.vim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'sjl/badwolf'

call plug#end()

set hidden
" Set 'nocompatible' to ward off unexpected things that your distro might have made 
set nocompatible
" Attempt to determine the type of a file based on its name and possibly its
" contents.
filetype indent plugin on
" syntax highligthing on
syntax on
" highlight search
set hlsearch
" Better command-line completion
set wildmenu
" Show partial commands in the last line of the screen
set showcmd
" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase
" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start
" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent
 
" Stop certain movements from always going to the first character of a line.
set nostartofline
" Display the cursor position on the last line of the screen or in the status line of a window
set ruler
" Always display the status line, even if only one window is displayed
set laststatus=2
" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm
" Use visual bell instead of beeping when doing something wrong
set visualbell
" And reset the terminal code for the visual bell. If visualbell is set, and
" this line is also included, vim will neither flash nor beep. If visualbell
" is unset, this does nothing.
set t_vb=
" Enable use of the mouse for all modes
set mouse=a
" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
set cmdheight=2
" Display line numbers on the left
set number
" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200
" Use <F11> to toggle between 'paste' and 'nopaste'
set pastetoggle=<F11>
" Indentation settings for using 4 spaces instead of tabs.
" Do not change 'tabstop' from its default value of 8 with this setup.
set shiftwidth=4
set softtabstop=4
set expandtab
"------------------------------------------------------------
" Mappings {{{1
"
" Useful mappings
 
" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
map Y y$
" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-L> :nohl<CR><C-L>
" disable menu bar and scrollbars
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar

"leader 
let mapleader = ","

" FONT
set guifont=Ubuntu\ Mono\ 13
" COLORSCHEME
set termguicolors
set background=dark
colorscheme badwolf
let g:lightline = {'colorscheme': 'badwolf'}


" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" Syntax completion
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers = ['flake8']

" deoplete 
let g:deoplete#enable_at_startup = 1
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif


" Haskell
set rtp+=~/.vim/plugged/LanguageClient-neovim/
let g:LanguageClient_serverCommands = { 'haskell': ['hie-wrapper'] }

augroup Haskell
    autocmd BufWrite *.hs :Autoformat
    " Don't automatically indent on save, since vim's autoindent for haskell is buggy
    autocmd FileType haskell let b:autoformat_autoindent=0
augroup end

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
map <Leader>lk :call LanguageClient#textDocument_hover()<CR>
map <Leader>lg :call LanguageClient#textDocument_definition()<CR>
map <Leader>lr :call LanguageClient#textDocument_rename()<CR>
map <Leader>lf :call LanguageClient#textDocument_formatting()<CR>
map <Leader>lb :call LanguageClient#textDocument_references()<CR>
map <Leader>la :call LanguageClient#textDocument_codeAction()<CR>
map <Leader>ls :call LanguageClient#textDocument_documentSymbol()<CR>

" format file
map <F7> gg=G<C-o><C-o>
" autoformat python with black on save 
" autocmd BufWritePre *.py execute ':Black'
" remove trailing whitespace in source files
autocmd FileType c,cpp,java,php,python autocmd BufWritePre <buffer> %s/\s\+$//e
