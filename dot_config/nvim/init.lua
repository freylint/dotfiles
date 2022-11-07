
-- Bootstrap plugin manager
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
  -- General
  use {
    'wbthomason/packer.nvim',
    'nvim-lua/plenary.nvim'
  }

  -- Aesthetics
  use {
    'Mofiqul/adwaita.nvim',
    -- TODO configure this
    'stevearc/dressing.nvim',
    -- TODO configure
    'nvim-lualine/lualine.nvim'
  }

  -- Editor Features
  use {
    -- TODO configure
    'jghauser/mkdir.nvim'
  }
  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup()
    end
  }
  use {
    'ggandor/leap.nvim',
    config = function()
      require('leap').add_default_mappings()
    end
  }
  use {
    'max397574/better-escape.nvim',
    config = function()
      require("better_escape").setup()
    end,
  }

  -- IDE Features
  use {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig',
    'neovim/nvim-lspconfig',
    'simrat39/rust-tools.nvim',
    'mfussenegger/nvim-dap',
    'nmac427/guess-indent.nvim',
    'gpanders/editorconfig.nvim',
    'mhartington/formatter.nvim',
    'nvim-tree/nvim-web-devicons',
    'nvim-treesitter/nvim-treesitter',
  }

  use {
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
  }

  use {
    -- TODO configure
    'Saecki/crates.nvim',
    -- TODO configure
    'pianocomposer321/yabs.nvim',
    -- TODO combine with friendly snippets
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)

-- Cfg Aliases
local cmd = vim.cmd
local fn = vim.fn
local g = vim.g
local opt = vim.opt

-- Nvim configuration
opt.number = true
opt.relativenumber = true
opt.completeopt = {'menuone', 'noinsert', 'noselect'}
opt.background = 'dark'
opt.autoread = true
opt.expandtab = true
opt.hidden = true
opt.ignorecase = true
opt.termguicolors = true
opt.wrap = false
opt.scrolloff = 8
opt.clipboard = "unnamedplus"
opt.splitright = true
opt.splitbelow = true
vim.wo.signcolumn = "yes"

vim.g.adwaita_darker = true
vim.cmd([[colorscheme adwaita]])

vim.cmd([[
set encoding=utf-8
set fileencoding=utf-8
]])

g.mapleader = ' '
g.maplocalleader = ' '


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

require'nvim-treesitter.configs'.setup({
  auto_install = true,
  highlight = {
    disable = function(_lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end
  }
})

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {"sumneko_lua", "rust_analyzer"}
})

local cmp = require("cmp")
cmp.setup({
})

require("lspconfig").sumneko_lua.setup({
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        path = runtime_path,
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

require("lspconfig").rust_analyzer.setup({
})

-- TODO use ansible-lint from mason install
require("lspconfig").ansiblels.setup({})

-- Set up editor features
require'nvim-web-devicons'.setup()
require('guess-indent').setup {}

