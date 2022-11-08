require('plugins').setup()

-- Nvim configuration
local g, o, cmd, opt = vim.g, vim.o, vim.cmd, vim.opt
g.mapleader = ' '
g.maplocalleader = ' '

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

-- Format on save
cmd([[
  augroup FormatAutogroup
    autocmd!
    autocmd BufWritePost * FormatWrite
  augroup END
]])

-- Set up IDE features
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

-- Dont run treesitter on files >100 KB
require'nvim-treesitter.configs'.setup({
  auto_install = true,
  highlight = {
    disable = function(_lang, buf)
        local max_filesize = 100 * 1024
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end
  }
})

require('langs').setup()

-- Set up editor features
require('nvim-web-devicons').setup()
require('guess-indent').setup {}
require('dressing').setup ()

require('lualine').setup({
  options = {
    theme = 'adwaita',
  }
})
