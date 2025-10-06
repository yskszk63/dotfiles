vim.opt.mouse = ""
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes:1"
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.pumblend = 20
vim.opt.winblend = 20
vim.opt.clipboard = { "unnamed", "unnamedplus" }
if vim.env.TERM == "foot" then
  vim.g.clipboard = "osc52"
end
if vim.fn.executable "zsh" == 1 then
  vim.opt.sh = "zsh"
end
vim.opt.winborder = 'rounded'

vim.g.vimsyn_embed = "l"
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.ft")
require("config.keymap")
require("config.term")

-- lazy.nvim
require("config.lazy")
