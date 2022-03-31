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

" Enable mouse support
set mouse=a

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

" Rainbow Parenthesis
Plug 'frazrepo/vim-rainbow'

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

" vim-smoothie for smooth scroll
Plug 'psliwka/vim-smoothie'

" tmux airline
Plug 'edkolev/tmuxline.vim'

" For lsp server
" for help, go to https://medium.com/@pttlens/vim%EC%9D%84-%EC%97%90%EB%94%94%ED%84%B0%EB%A1%9C-%ED%99%9C%EC%9A%A9%ED%95%98%EA%B8%B0-2-ide%EB%A1%9C-%ED%99%9C%EC%9A%A9%ED%95%98%EA%B8%B0-e04564fedb9e
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'mattn/vim-lsp-settings'

" For Specific Languages

" Bluespec
Plug 'mtikekar/vim-bsv'

" Ocaml
" Syntastic
Plug 'vim-syntastic/syntastic'
" VimCompletesMe
Plug 'ackyshake/VimCompletesMe'

call plug#end()


" Airline Theme
let g:airline_powerline_fonts=1
let g:airline_theme='onedark'

" Set tmuxline at start of tmux
let g:airline#extensions#tmuxline#enabled = 1
let airline#extensions#tmuxline#snapshot_file = "~/.tmux-status.conf"

" Rainbow Parenthesis
let g:rainbow_active = 1
let g:rainbow_load_separately = [
            \ [ '*' , [['(', ')'], ['\[', '\]'], ['{', '}'], ['begin', 'end']]],
            \ [ '*.bsv' , [['(', ')'], ['\[', '\]'], ['{', '}'], ['begin', 'end'], ['case', 'endcase'], ['method', 'endmethod'], ['rule', 'endrule']]]
            \ ]

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

" GitGutter
let g:gitgutter_enabled = 0

" Lsp Settings
" Error message on status
let g:lsp_diagnostics_echo_cursor = 0

" Error message on floating window
let g:lsp_diagnostics_float_cursor = 1

" Error message next to the code
let g:lsp_diagnostics_virtual_text_enabled = 1

" Lsp language that is supported by vim-lsp-settings
let g:lsp_settings = {
\   'pyls-all': {
\       'workspace_config': {
\           'pyls': {
\               'plugins': {
\                   'pycodestyle': {
\                       'enabled': v:false
\                   },
\                   'pydocstyle': {
\                       'enabled': v:false
\                   }
\               }
\           }
\       }
\   }
\}

" Lsp language that is unsupported by vim-lsp-settings
if executable('bash-language-server')
  augroup LspBash
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'bash-language-server',
          \ 'cmd': {server_info->[&shell, &shellcmdflag, 'bash-language-server start']},
          \ 'allowlist': ['sh'],
          \ })
  augroup END
endif

if executable('ocaml-language-server')
    au User lsp_setup call lsp#register_server({
          \ 'name': 'ocaml-language-server',
          \ 'cmd': {server_info->[&shell, &shellcmdflag, 'opam config exec -- ocaml-language-server --stdio']},
          \ 'whitelist': ['reason', 'ocaml'],
          \ })
endif

" For Ocaml Merlin
" merlin
let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"
