local set = vim.opt
local cmd = vim.cmd
local api = vim.api

local key = vim.keymap.set

-- comma as leader
vim.g.mapleader = ','
set.timeout = false

-- use current dir
-- set.browsedir  = 'last'

-- show tabs and spaces
set.list = true

-- tabs / indent
set.shiftwidth = 4
set.tabstop = 4
set.smartindent = true
set.autoindent = true
set.expandtab = true

-- side numbers, relative to the cursor
set.number = true
set.relativenumber = true

-- lualine does this
set.showmode = false

-- lazy install from source
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({'git', 'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git', '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


-- Plugins
require('lazy').setup({
    -- LSP
    'neovim/nvim-lspconfig',
    'nvim-treesitter/nvim-treesitter',
    'ray-x/lsp_signature.nvim',
    {
        'mrcjkb/haskell-tools.nvim',
        version = '^3',
        ft = { 'haskell', 'lhaskell', 'cabal', 'cabalproject'},
    },
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    -- colorschemes
    'folke/tokyonight.nvim',
    'rktjmp/lush.nvim',
    {
        "baliestri/aura-theme",
        lazy = false,
        priority = 1000,
        config = function(plugin)
          vim.opt.rtp:append(plugin.dir .. "/packages/neovim")
          vim.cmd([[colorscheme aura-dark]])
        end
    },
    {
        "neanias/everforest-nvim",
        version = false,
        lazy = false,
        priority = 1000, -- make sure to load this before all the other start plugins
    },

    -- line
    'nvim-lualine/lualine.nvim',

    -- file explorer
    'kyazdani42/nvim-tree.lua',

    -- menu
    'nvim-telescope/telescope.nvim',
    'weilbith/nvim-code-action-menu',

    -- terminal
    'akinsho/toggleterm.nvim',

    -- completions
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-nvim-lsp',
    -- 'saadparwaiz1/cmp_luasnip',
    'L3MON4D3/LuaSnip',
    'rafamadriz/friendly-snippets',

    -- syntacies
    'theRealCarneiro/hyprland-vim-syntax',

    -- dependencies
    'nvim-lua/plenary.nvim'
})

vim.lsp.inlay_hint.enable()

-- set colorscheme
vim.cmd('colorscheme everforest')

require('lualine').setup({})

local telescope = require('telescope')
telescope.setup({})

require('nvim-tree').setup({})

require('cmp').setup({})

require('lsp_lines').setup({})
-- Disable virtual_text since it's redundant due to lsp_lines.
vim.diagnostic.config({
  virtual_text = false,
})

require('toggleterm').setup({
    open_mapping = '<C-t>',
    direction = 'float',
    shade_terminals = true
})

-- require('hyprland-vim-syntax')

key('n', '<C-w>', '<cmd>wa<cr>')

key('n', '<leader>eo', '<cmd>NvimTreeToggle<cr>')
key('n', '<leader>ef', '<cmd>NvimTreeFocus<cr>')

key('n', '<leader>tb', '<cmd>Telescope buffers<cr>')
key('n', '<leader>tf', '<cmd>Telescope find_files<cr>')
key('n', '<leader>td', '<cmd>Telescope diagnostics<cr>')
key('n', '<leader>tg', '<cmd>Telescope live_grep search-dirs=.<cr>')
key('n', '<leader>ts', '<cmd>Telescope lsp_document_symbols<cr>')
key('n', '<leader>tc', '<cmd>Telescope commands<cr>')

require('nvim-treesitter.configs').setup({
    highlight = {
        enable = true
    }
})

local nvim_lsp = require('lspconfig')
-- nvim_lsp.hls.setup {}
nvim_lsp.pyright.setup {}
nvim_lsp.texlab.setup {}

vim.lsp.set_log_level(0)

api.nvim_create_autocmd('LspAttach', {
    group = api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)

        local c = vim.lsp.get_client_by_id(ev.data.client_id)
        for k, v in ipairs(c) do
            print(k, v)
        end

        local opts = { buffer = ev.buf }
        key({'n', 'v'}, '<leader>s', '<cmd>CodeActionMenu<cr>', opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<leader>f', function()
          vim.lsp.buf.format { async = true }
        end, opts)
    end
})
