local opts = { noremap = true, silent = true }

-- Revert old behavior for https://github.com/neovim/neovim/pull/13268
vim.api.nvim_del_keymap("n", "Y")

-- https://neovim.discourse.group/t/go-to-definition-in-new-tab/1552/2
vim.keymap.set("n", "gd", "<Cmd>tab split | lua vim.lsp.buf.definition()<CR>", opts)
--vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

vim.keymap.set("n", "]g", "]d", { remap = true })
vim.keymap.set("n", "[g", "[d", { remap = true })

vim.keymap.set("n", "<C-k>", "gt", { remap = true })
vim.keymap.set("n", "<C-j>", "gT", { remap = true })
--vim.keymap.set("n", "<Leader>e", "<Cmd>bd<CR>", opts)
vim.keymap.set("n", "<Leader>e", "<Cmd>quit<CR>", opts)

vim.keymap.set("v", "<C-/>", "gc", { remap = true })

vim.keymap.set("n", "<Leader>i", function ()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, opts)
