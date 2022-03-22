" For line number and syntax
set number
syntax on

" Allow crosshair cursor highlighting.
hi CursorLine   cterm=NONE ctermbg=0
hi CursorColumn cterm=NONE ctermbg=0
set cursorline
set cursorcolumn
" If you prefer to toggle cursorline use below
" nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>

" For Indentation set to 4 spaces
set tabstop=4 "Sets indent size of tabs"
set softtabstop=4 "Soft tabs"
set expandtab "Turns tabs into spaces"
set shiftwidth=4 "Sets auto-indent size"
set autoindent "Turns on auto-indenting"
set copyindent "Copy the previous indentation on autoindenting"
set smartindent "Remembers previous indent when creating new lines"

" For Tab autocompletion (requires asyncomplete plugin)
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
" If you prefer the enter key to always insert a new line even if a popup menu
" is visible, enable below line
" inoremap <expr> <cr> pumvisible() ? asyncomplete#close_popup() . '\<cr>" : '\<cr>"


" Plugins (Install the vim-plug)
call plug#begin()
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Vim (Windows): '~/vimfiles/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'

" VimCompletesMe
Plug 'ackyshake/VimCompletesMe'

" Rainbow Parenthesis
Plug 'nvie/vim-flake8'

" Line for indentation
Plug 'nathanaelkane/vim-indent-guides'

" Highlight the copied (yanked) parts
Plug 'machakann/vim-highlightedyank'

" airline
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-airline/vim-airline'

" Add something surround
Plug 'tpope/vim-surround'

" For comment easy
Plug 'preservim/nerdcommenter'

" Nerd Tree
Plug 'scrooloose/nerdtree'

" Display what has been changed since last git
Plug 'airblade/vim-gitgutter'

" For more information in search
Plug 'osyo-manga/vim-anzu'

" A class outline viewer (informations such as variables, ...)
Plug 'majutsushi/tagbar'

" Syntastic
Plug 'vim-syntastic/syntastic'

" vim-smoothie for smooth scroll
Plug 'psliwka/vim-smoothie'

" For lsp server
" for help, go to https://medium.com/@pttlens/vim%EC%9D%84-%EC%97%90%EB%94%94%ED%84%B0%EB%A1%9C-%ED%99%9C%EC%9A%A9%ED%95%98%EA%B8%B0-2-ide%EB%A1%9C-%ED%99%9C%EC%9A%A9%ED%95%98%EA%B8%B0-e04564fedb9e
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'mattn/vim-lsp-settings'


" NERD Commenter
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Set a language to use its alternate delimiters by default
" let g:NERDAltDelims_java = 1
" Add your own custom formats or override the defaults
" let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
" customize keymapping
" map <Leader>cc <plug>NERDComToggleComment
" map <Leader>c<space> <plug>NERDComComment


" VimCompletesMe
" Ocaml
autocmd FileType ocaml let b:vcm_tab_complete = "omni"

" Syntastic
" For merlin support
let g:syntastic_ocaml_checkers = ['merlin']

" For Specific Languages

" Bluespec
Plug 'mtikekar/vim-bsv'

call plug#end()

" For Ocaml Merlin
" merlin
let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"
