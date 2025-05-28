-- All plugins

return {
    -- LSP
    'neovim/nvim-lspconfig',
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    'nvim-treesitter/nvim-treesitter',
    "aznhe21/actions-preview.nvim",
    'weilbith/nvim-code-action-menu',
    'ray-x/lsp_signature.nvim',
    {
        'mrcjkb/haskell-tools.nvim',
        version = '^3',
        ft = { 'haskell', 'lhaskell', 'cabal', 'cabalproject'},
    },
    -- TODO
    -- "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
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
}
