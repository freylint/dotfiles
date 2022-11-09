require('plugins').setup()

-- Nvim configuration
local g, o, cmd, opt = vim.g, vim.o, vim.cmd, vim.opt

o.splitbelow = true
o.splitright = true
o.showmatch = true
o.laststatus = 3
o.ff = "unix"
o.formatoptions = "cqrnj"

o.hidden = true
o.swapfile = false
o.backup = false
o.writebackup = false

o.clipboard = "unnamedplus"
o.scrolloff = 10
o.emoji = true
o.termguicolors = true

opt.completeopt = {'menuone', 'noinsert', 'noselect'}
o.shortmess = "filnxtToOFc"
o.signcolumn = "yes:1"
o.mouse = "nv"

opt.number = true
opt.relativenumber = true
opt.autoread = true
opt.expandtab = true
opt.ignorecase = true
opt.wrap = false
opt.background = 'dark'
g.adwaita_darker = true

vim.cmd([[colorscheme adwaita]])

vim.cmd([[
set encoding=utf-8
set fileencoding=utf-8
]])

require('editor').setup()
require('langs').setup()
require('keymap').setup()

