" For syntax
syntax on

" For hybrid line numbers
set number relativenumber

" Set vertical rulers
set colorcolumn=80,120

" Allow crosshair cursor highlighting.
hi CursorLine   cterm=NONE ctermbg=0
" hi CursorColumn cterm=NONE ctermbg=0
set cursorline
" set cursorcolumn
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

" set leader key as spacebar
let mapleader = " "

" set copy & paste with system clipboard using leader key
vmap <leader>y "+y
vmap <leader>d "+d
nmap <leader>y "+yy
nmap <leader>p "+p
nmap <leader>P "+P
vmap <leader>p "+p
vmap <leader>P "+P

" Set popup instant
set timeoutlen=500
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
Plug 'preservim/tagbar'

" vim-smoothie for smooth scroll
Plug 'psliwka/vim-smoothie'

" detect indent
Plug 'Darazaki/indent-o-matic'

" easymotion
Plug 'easymotion/vim-easymotion'

" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Toggle Terminal
Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}

" shortcut popup
Plug 'folke/which-key.nvim'

" THEMES
" Tokyonight theme
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
" One Half
Plug 'sonph/onehalf', {'rtp': 'vim/'}

" icons
Plug 'nvim-tree/nvim-web-devicons'
Plug 'onsails/lspkind.nvim'

" UI Enhancer
Plug 'stevearc/dressing.nvim'

" css color
Plug 'ap/vim-css-color'

" indent line
Plug 'yggdroot/indentline'

" kotlin syntax highlighting
Plug 'udalov/kotlin-vim'

" Auto pair close
Plug 'windwp/nvim-autopairs'

" Improve Performance
Plug 'lewis6991/impatient.nvim'

" LSP Support
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

" Autocompletion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lua'

"  Snippets
Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'

" LSP settings
Plug 'VonHeikemen/lsp-zero.nvim'

call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" auto pair
lua <<EOF
require('nvim-autopairs').setup {}
EOF

" Airline theme
let g:airline_powerline_fonts=1
let g:airline_theme='tomorrow'

" colorscheme
" let g:tokyonight_style = 'storm'
colorscheme tokyonight

" Rainbow Parenthesis
let g:rainbow_active = 1
let g:rainbow_load_separately = [
            \ [ '*' , [['(', ')'], ['\[', '\]'], ['{', '}'], ['begin', 'end']]],
            \ [ '*.bsv' , [['(', ')'], ['\[', '\]'], ['{', '}'], ['begin', 'end'], ['case', 'endcase'], ['method', 'endmethod'], ['rule', 'endrule']]]
            \ ]

" indent-o-matic settings
lua << EOF
require('indent-o-matic').setup {
    -- The values indicated here are the defaults

    -- Number of lines without indentation before giving up (use -1 for infinite)
    max_lines = 2048,

    -- Space indentations that should be detected
    standard_widths = { 2, 4, 8 },

    -- Skip multi-line comments and strings (more accurate detection but less performant)
    skip_multiline = true,
}
EOF

" NERDTree shortcut
nmap <leader>e :NERDTreeToggle<CR>

" fzf shortcut
nmap <leader>f :Files<CR>

" GitGutter
let g:gitgutter_enabled = 0

" ToggleTerm Settings
lua << EOF
require('toggleterm').setup{
    size = 30,
    open_mapping = [[<c-\>]],
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = '1',
    start_in_insert = true,
    persist_size = true,
    direction = 'horizontal'
}
EOF

" which-key Settings
lua << EOF
local wk = require('which-key')
wk.register(mappings, opts)
EOF

" impatient
lua << EOF
require('impatient')
EOF

" webdevicons
lua << EOF
require('nvim-web-devicons').setup()
EOF

" lspkind
lua << EOF
require('lspkind').init({
    -- DEPRECATED (use mode instead): enables text annotations
    --
    -- default: true
    -- with_text = true,

    -- defines how annotations are shown
    -- default: symbol
    -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
    mode = 'symbol_text',

    -- default symbol map
    -- can be either 'default' (requires nerd-fonts font) or
    -- 'codicons' for codicon preset (requires vscode-codicons font)
    --
    -- default: 'default'
    preset = 'codicons',

    -- override preset symbols
    --
    -- default: {}
    symbol_map = {
      Text = "",
      Method = "",
      Function = "",
      Constructor = "",
      Field = "ﰠ",
      Variable = "",
      Class = "ﴯ",
      Interface = "",
      Module = "",
      Property = "ﰠ",
      Unit = "塞",
      Value = "",
      Enum = "",
      Keyword = "",
      Snippet = "",
      Color = "",
      File = "",
      Reference = "",
      Folder = "",
      EnumMember = "",
      Constant = "",
      Struct = "פּ",
      Event = "",
      Operator = "",
      TypeParameter = ""
    },
})
EOF

" Lsp Settings
lua <<EOF
local lsp = require('lsp-zero')

lsp.preset('recommended')
lsp.setup()
EOF

let g:LanguageClient_useVirtualText = 1