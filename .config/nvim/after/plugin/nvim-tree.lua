local api = require "nvim-tree.api"

local function tree_on_attach(bufnr)
    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- default mappings
    api.config.mappings.default_on_attach(bufnr)

    -- custom mappings
    vim.keymap.set('n', '<Right>', api.tree.change_root_to_node, opts('CD'))
    vim.keymap.set('n', '<Left>', api.tree.change_root_to_parent, opts('Down'))

    vim.keymap.set('n', '<Esc>', api.tree.close, opts('Close'))
end

require("nvim-tree").setup {
    on_attach = tree_on_attach,
    filters = {
        git_ignored = false
    }
}
