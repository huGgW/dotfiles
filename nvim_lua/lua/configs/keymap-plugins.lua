-- Use command as possible, to trigger lazy with command

local function command(cmd)
  return function()
    vim.api.nvim_command(cmd)
  end
end

-- File Tree
-- map('n', '<Leader>te', ':NvimTreeToggle<CR>', { desc = "Toggle Nvim Tree" })
vim.keymap.set('n', '<Leader>te', command('Neotree toggle'), { desc = "Toggle File Tree" })

-- Oil.nvim
-- map('n', '<Leader>to', ':Oil<CR>', { desc = "Toggle Oil.nvim" })
vim.keymap.set('n', '<Leader>to', command('Oil'), { desc = "Toggle Oil.nvim" })


-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>fo', builtin.find_files, { desc = "Find Files" })
vim.keymap.set('n', '<leader>fs', builtin.live_grep, { desc = "Search from all files" })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Find buffers" })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Find help tags" })
vim.keymap.set('n', '<leader>fd', builtin.lsp_dynamic_workspace_symbols, { desc = "Find symbols" })
vim.keymap.set('n', '<leader>fp', builtin.commands, { desc = "Find commands" })

-- keymap to toggle aerial
vim.keymap.set("n", "<leader>o", command( "AerialToggle"), { desc = "Toggle outline" })

-- Guess Indent
vim.keymap.set('n', '<Leader>i', command('GuessIndent'), { desc = "Guess Indent" })

-- Lsp
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, { desc = "Open diagnostic float" })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, { desc = "Set loclist" })

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    local function addDesc(desc)
      local newOpts = {}
      for k, v in pairs(opts) do
        newOpts[k] = v
      end
      newOpts["desc"] = desc
      return newOpts
    end
    -- definitions, implementations
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, addDesc("Go to definition"))
    vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, addDesc("Go to implementation"))
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, addDesc("Go to references"))
    vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, addDesc("Go to type definition"))
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, addDesc("Go to declaration"))

    -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts )
    vim.keymap.set('n', '<leader>k', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<f2>', vim.lsp.buf.rename, opts)
    -- vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>fm', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

-- Lsp Saga
vim.keymap.set('n', 'gpd', command('Lspsaga peek_definition'), { desc = "Peek definition" })
vim.keymap.set({ 'n', 'v' }, '<leader>a', command('Lspsaga code_action'), { desc = "Code action" })

-- Dap
vim.keymap.set('n', '<f5>', command('DapContinue'), { desc = "Continue" })
vim.keymap.set('n', '<leader>b', command('DapToggleBreakpoint'), { desc = "Toggle breakpoint" })

-- UFO (Improved Fold)
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

-- LazyGit
vim.keymap.set('n', '<leader>lg', command('LazyGit'), { desc = "LazyGit" })
