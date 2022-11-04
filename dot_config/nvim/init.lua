-- Aliases
local cmd = vim.cmd
local fn = vim.fn
local g = vim.g
local opt = vim.opt

-- Bootstrap plugin manager
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    'git',
    'clone',
    '--depth', '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path
  })
end

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

g.mapleader = ' '
g.maplocalleader = ','


-- Format on save
cmd([[
  augroup FormatAutogroup
    autocmd!
    autocmd BufWritePost * FormatWrite
  augroup END
]])

-- Set up IDE features
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-lspconfig").setup_handlers {
  -- Cfg for unconfigured language servers
  function (server_name)
    require('guess-indent').setup {}
    require('editorconfig').properties.foo = function(bufnr, val)
      vim.b[bufnr].foo = val
    end
    require("lspconfig")[server_name].setup {}
  end,

  -- Cfg for Rust language server
  ["rust_analyzer"] = function ()
    require('guess-indent').setup {}
    require('editorconfig').properties.foo = function(bufnr, val)
      vim.b[bufnr].foo = val
    end
    require("rust-tools").setup {
      dap = {
        adapter = {
        type = "executable",
        command = "lldb-vscode",
        name = "rt_lldb",
        },
      },
    }
  end
}

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
--require'nvim-web-devicons'.setup()

return require('packer').startup(function(use)
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
    -- TODO configure
    'Saecki/crates.nvim',
    -- TODO configure
    'pianocomposer321/yabs.nvim',
  -- TODO combine with friendly snippets
    'L3MON4D3/LuaSnip'
  }


end)

