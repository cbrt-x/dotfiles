local set = vim.opt
local api = vim.api


-- comma as leader
vim.g.mapleader = ","
set.timeout = false

-- show tabs and spaces
set.list = true

-- tabs / indent
set.shiftwidth = 4
set.tabstop = 4
set.smartindent = true
set.autoindent = true
set.expandtab = true

set.updatetime = 500
set.cursorline = true

-- side numbers, relative to the cursor
set.number = true
set.relativenumber = true

-- lualine does this
set.showmode = false

require("./lazy-nvim")

-- Plugins
require("lazy").setup({
    spec = {
        import = "plugins",
    },
})

-- vim.lsp.inlay_hint.enable()


require("catppuccin").setup({
    integrations = {
        native_lsp = {
            enabled = true,
            virtual_text = {
                errors = { "italic" },
                hints = { "italic" },
                warnings = { "italic" },
                information = { "italic" },
                ok = { "italic" },
            },
            underlines = {
                errors = { "underline" },
                hints = { "underline" },
                warnings = { "underline" },
                information = { "underline" },
                ok = { "underline" },
            },
            inlay_hints = {
                background = true,
            },
        },

        telescope = {
            enabled = true,
        }
    }
})

-- set colorscheme
vim.cmd("colorscheme catppuccin-frappe")

-- require("lualine").setup({})

require("telescope").setup({})

require("cmp").setup({})

-- require("lsp_lines").setup({})
-- Disable virtual_text since it's redundant due to lsp_lines.
-- vim.diagnostic.config({
--    virtual_text = false,
--})

require("toggleterm").setup({
    open_mapping = "<C-t>",
    direction = "horizontal",
    shade_terminals = true,
    persist_mode = false,
    autochdir = true,
})

-- require('hyprland-vim-syntax')
local key = vim.keymap.set

key("n", "<leader>rc", "<cmd>source $MYVIMRC<cr>")

key("n", "<leader>e", "<cmd>NvimTreeOpen<cr>")
key("n", "<leader>lf", "<cmd>NvimTreeFindFile<cr>")

key("n", "<leader>tb", "<cmd>Telescope buffers<cr>")
key("n", "<leader>tf", "<cmd>Telescope find_files<cr>")
key("n", "<leader>td", "<cmd>Telescope diagnostics<cr>")
key("n", "<leader>tg", "<cmd>Telescope live_grep search-dirs=.<cr>")
key("n", "<leader>ts", "<cmd>Telescope lsp_document_symbols<cr>")
key("n", "<leader>tc", "<cmd>Telescope commands<cr>")

key("n", "<C-Left>", "<cmd>wincmd h<cr>")
key("n", "<C-Right>", "<cmd>wincmd l<cr>")
key("n", "<C-Down>", "<cmd>wincmd j<cr>")
key("n", "<C-Up>", "<cmd>wincmd k<cr>")

key("t", "<Esc>", "<C-\\><C-N><C-w><C-p>")
-- TODO Why no work
key("n", "<leader>a", "cmd>echo \"hi\"<cr>")
key({"n", "v"}, "<leader>cs", "<cmd>ToggleTermSendVisualSelection<cr>")

require("nvim-treesitter.configs").setup({
    highlight = {
        enable = true,
    },
})

require("actions-preview").setup({
    layout_strategy = "horizontal",
})

local nvim_lsp = require("lspconfig")
-- nvim_lsp.hls.setup {}
nvim_lsp.pyright.setup({})
nvim_lsp.texlab.setup({})
nvim_lsp.lua_ls.setup({
    settings = {
        Lua = {
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file('', true),
            },
        }
    }
})

api.nvim_create_autocmd("LspAttach", {
    group = api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        local opts = { buffer = ev.buf }
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        key({ "n", "v" }, "<leader>s", require('actions-preview').code_actions, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", opts)
        vim.keymap.set("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })
        end, opts)

        if client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
            vim.api.nvim_clear_autocmds { buffer = ev.buf, group = "lsp_document_highlight" }
            vim.api.nvim_create_autocmd("CursorMoved", {
                callback = vim.lsp.buf.clear_references,
                buffer = ev.buf,
                group = "lsp_document_highlight",
                desc = "Clear All the References",
            })
        end
    end,
})
