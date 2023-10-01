local set = vim.opt
local cmd = vim.cmd
local api = vim.api

local key = vim.keymap.set

-- comma as leader
vim.g.mapleader = ','
set.timeout = false

-- use current dir
set.browsedir  = 'last'

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

    -- colorschemes
    'folke/tokyonight.nvim',
    'rktjmp/lush.nvim',

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
    'saadparwaiz1/cmp_luasnip',
    'L3MON4D3/LuaSnip',
    'rafamadriz/friendly-snippets',

    -- syntacies
    'theRealCarneiro/hyprland-vim-syntax',

    -- dependencies
    'nvim-lua/plenary.nvim'
})

-- set colorscheme
vim.cmd('colorscheme tokyonight')

require('lualine').setup({
})

local telescope = require('telescope')
telescope.setup({})

require('nvim-tree').setup({})

require('cmp').setup({})

require('toggleterm').setup({
    open_mapping = '<C-t>',
    direction = 'float',
    shade_terminals = true
})

-- require('hyprland-vim-syntax')


key('n', '<leader>e', '<cmd>NvimTreeToggle<cr>')

key('n', '<leader>tb', '<cmd>Telescope buffers<cr>')
key('n', '<leader>tf', '<cmd>Telescope find_files<cr>')
key('n', '<leader>td', '<cmd>Telescope diagnostics<cr>')
key('n', '<leader>ts', '<cmd>Telescope lsp_document_symbols<cr>')
key('n', '<leader>tc', '<cmd>Telescope commands<cr>')

require('nvim-treesitter.configs').setup({
    highlight = {
        enable = true
    }
})

require('lsp_signature').setup({})

-- require('')

local nvim_lsp = require('lspconfig')
nvim_lsp.hls.setup {}
nvim_lsp.pyright.setup {}
nvim_lsp.texlab.setup {}

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


local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
  return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
  return
end

require("luasnip/loaders/from_vscode").lazy_load()

local check_backspace = function()
  local col = vim.fn.col "." - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

--   פּ ﯟ   some other good icons
local kind_icons = {
  Text = "",
  Method = "m",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "",
  Interface = "",
  Module = "",
  Property = "",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "",
}
-- find more here: https://www.nerdfonts.com/cheat-sheet

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = {
    ["<C-k>"] = cmp.mapping.select_prev_item(),
    ["<C-j>"] = cmp.mapping.select_next_item(),
    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ["<C-e>"] = cmp.mapping {
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    },
    -- Accept currently selected item. If none selected, `select` first item.
    -- Set `select` to `false` to only confirm explicitly selected items.
    ["<CR>"] = cmp.mapping.confirm { select = true },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expandable() then
        luasnip.expand()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif check_backspace() then
        fallback()
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
  },
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      -- Kind icons
      vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
      -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        luasnip = "[Snippet]",
        buffer = "[Buffer]",
        path = "[Path]",
      })[entry.source.name]
      return vim_item
    end,
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  },
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },
  window = {
    documentation = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    },
  },
  experimental = {
    ghost_text = false,
    native_menu = false,
  },
}
