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


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

" AutoComplete Parenthesis
" Plug 'Raimondi/delimitMate'
Plug 'cohama/lexima.vim'

" multiple-cursors (like vscode)
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

" Highlight the copied (yanked) parts
Plug 'machakann/vim-highlightedyank'

" airline
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-airline/vim-airline'

" Add something surround
Plug 'tpope/vim-surround'

" For comment easy
Plug 'tpope/vim-commentary'

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

" detect indent
Plug 'ciaranm/detectindent'

" easymotion
Plug 'easymotion/vim-easymotion'

" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" For lsp server
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Tagbar: class outline viewer
Plug 'preservim/tagbar'

" Tokyonight theme
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Unused plugins (used in past configuration)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" " for help, go to https://medium.com/@pttlens/vim%EC%9D%84-%EC%97%90%EB%94%94%ED%84%B0%EB%A1%9C-%ED%99%9C%EC%9A%A9%ED%95%98%EA%B8%B0-2-ide%EB%A1%9C-%ED%99%9C%EC%9A%A9%ED%95%98%EA%B8%B0-e04564fedb9e
" Plug 'prabirshrestha/async.vim'
" Plug 'prabirshrestha/vim-lsp'
" Plug 'prabirshrestha/asyncomplete.vim'
" Plug 'prabirshrestha/asyncomplete-lsp.vim'
" Plug 'mattn/vim-lsp-settings'

" For Specific Languages

" " Bluespec
" Plug 'mtikekar/vim-bsv'

" " Ocaml
" " Syntastic
" Plug 'vim-syntastic/syntastic'
" " VimCompletesMe
" Plug 'ackyshake/VimCompletesMe'

call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Airline Theme
let g:airline_powerline_fonts=1
let g:airline_theme='onedark'

" Set tmuxline at start of tmux
let g:airline#extensions#tmuxline#enabled = 1
let airline#extensions#tmuxline#snapshot_file = "~/.tmux-status.conf"

" " delimitMate (AutoComplete Parenthesis)
" let delimitMate_expand_cr=1

" Rainbow Parenthesis
let g:rainbow_active = 1
let g:rainbow_load_separately = [
            \ [ '*' , [['(', ')'], ['\[', '\]'], ['{', '}'], ['begin', 'end']]],
            \ [ '*.bsv' , [['(', ')'], ['\[', '\]'], ['{', '}'], ['begin', 'end'], ['case', 'endcase'], ['method', 'endmethod'], ['rule', 'endrule']]]
            \ ]


" GitGutter
let g:gitgutter_enabled = 0

" colorscheme
let g:tokyonight_style = 'storm'
colorscheme tokyonight
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Coc.nvim Settings

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
" nmap <leader>rn <Plug>(coc-rename)
nmap <F2> <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Unused Settings (Used in past configurations)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" " NERD Commenter
" " Add spaces after comment delimiters by default
" let g:NERDSpaceDelims = 1
" " Use compact syntax for prettified multi-line comments
" let g:NERDCompactSexyComs = 1
" " Align line-wise comment delimiters flush left instead of following code indentation
" let g:NERDDefaultAlign = 'left'
" " Set a language to use its alternate delimiters by default
" " let g:NERDAltDelims_java = 1
" " Add your own custom formats or override the defaults
" " let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
" " Allow commenting and inverting empty lines (useful when commenting a region)
" let g:NERDCommentEmptyLines = 1
" " Enable trimming of trailing whitespace when uncommenting
" let g:NERDTrimTrailingWhitespace = 1
" " customize keymapping
" " map <Leader>cc <plug>NERDComToggleComment
" " map <Leader>c<space> <plug>NERDComComment

" For Tab autocompletion (requires asyncomplete plugin)
" inoremap <expr> <Tab>   pumvisible() ? '\<C-n>' : '\<Tab>'
" inoremap <expr> <S-Tab> pumvisible() ? '\<C-p>' : '\<S-Tab>'
" inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : '\<cr>'
" If you prefer the enter key to always insert a new line even if a popup menu
" is visible, enable below line
" inoremap <expr> <cr> pumvisible() ? asyncomplete#close_popup() . '\<cr>" : '\<cr>"

" " Lsp Settings
" " Error message on status
" let g:lsp_diagnostics_echo_cursor = 1

" " Error message on floating window
" let g:lsp_diagnostics_float_cursor = 1

" " Error message next to the code
" let g:lsp_diagnostics_virtual_text_enabled = 1

" " Error highlighting
" let g:lsp_diagnostics_highlights_enabled = 1
" highlight link LspErrorHighlight Error

" " Lsp language that is supported by vim-lsp-settings
" let g:lsp_settings = {
" \   'pyls-all': {
" \       'workspace_config': {
" \           'pyls': {
" \               'plugins': {
" \                   'pycodestyle': {
" \                       'enabled': v:false
" \                   },
" \                   'pydocstyle': {
" \                       'enabled': v:false
" \                   }
" \               }
" \           },
" \           'pyls-ms': {
" \               'plugins': {
" \                   'pycodestyle': {
" \                       'enabled': v:false
" \                   },
" \                   'pydocstyle': {
" \                       'enabled': v:false
" \                   }
" \               }
" \           }
" \       }
" \   }
" \}

" " Lsp language that is unsupported by vim-lsp-settings
" if executable('bash-language-server')
"   augroup LspBash
"     autocmd!
"     autocmd User lsp_setup call lsp#register_server({
"           \ 'name': 'bash-language-server',
"           \ 'cmd': {server_info->[&shell, &shellcmdflag, 'bash-language-server start']},
"           \ 'allowlist': ['sh'],
"           \ })
"   augroup END
" endif

" if executable('ocaml-language-server')
"     au User lsp_setup call lsp#register_server({
"           \ 'name': 'ocaml-language-server',
"           \ })
" endif

" " For Ocaml Merlin
" " merlin
" let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
" execute 'set rtp+=' . g:opamshare . '/merlin/vim'
