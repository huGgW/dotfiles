" For line number and syntax
set number
syntax on

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

call plug#end()

" ## added by OPAM user-setup for vim / base ## 93ee63e278bdfc07d1139a748ed3fff2 ## you can edit, but keep this line
let s:opam_share_dir = system("opam config var share")
let s:opam_share_dir = substitute(s:opam_share_dir, '[\r\n]*$', '', '')

let s:opam_configuration = {}

function! OpamConfOcpIndent()
  execute "set rtp^=" . s:opam_share_dir . "/ocp-indent/vim"
endfunction
let s:opam_configuration['ocp-indent'] = function('OpamConfOcpIndent')

function! OpamConfOcpIndex()
  execute "set rtp+=" . s:opam_share_dir . "/ocp-index/vim"
endfunction
let s:opam_configuration['ocp-index'] = function('OpamConfOcpIndex')

function! OpamConfMerlin()
  let l:dir = s:opam_share_dir . "/merlin/vim"
  execute "set rtp+=" . l:dir
endfunction
let s:opam_configuration['merlin'] = function('OpamConfMerlin')

let s:opam_packages = ["ocp-indent", "ocp-index", "merlin"]
let s:opam_check_cmdline = ["opam list --installed --short --safe --color=never"] + s:opam_packages
let s:opam_available_tools = split(system(join(s:opam_check_cmdline)))
for tool in s:opam_packages
  " Respect package order (merlin should be after ocp-index)
  if count(s:opam_available_tools, tool) > 0
    call s:opam_configuration[tool]()
  endif
endfor
" ## end of OPAM user-setup addition for vim / base ## keep this line
" ## added by OPAM user-setup for vim / ocp-indent ## 82f69d7f2f609fe428f110bdc471782e ## you can edit, but keep this line
if count(s:opam_available_tools,"ocp-indent") == 0
  source "/home/whjoon0225/.opam/4.02.3/share/ocp-indent/vim/indent/ocaml.vim"
endif
" ## end of OPAM user-setup addition for vim / ocp-indent ## keep this line
