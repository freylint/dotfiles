-- work around the unused undefined global vim lint from sumneko
local vim = vim

-- Imports
local lsp_installer_servers = require'nvim-lsp-installer.servers'
local treesitter = require 'nvim-treesitter.configs'
local cmp = require 'cmp'
local cmp_lsp = require 'cmp_nvim_lsp'
local luasnip = require 'luasnip'
local rust_tools = require 'rust-tools'

local vimp = require('vimp')

local lualine = require 'lualine'

-- General
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true

vim.o.hidden = true

vim.o.history = 256

vim.o.tabstop = 4
vim.o.completeopt = "menu,menuone,noselect"
vim.o.shiftwidth = vim.o.tabstop


-- Keymap

local RenameKey = "<F2>"
local CmpScrollUpKey = "<F10>"
local CmpScrollDownKey = "<F9>"
local DocScrollUpKey = "<S-F10>"
local DocScrollDownKey = "<S-F9>"
local ExecCompletionKey = "<S-CR>"


-- Editor features config
vim.cmd('colorscheme gruvbox')
lualine.setup {
   theme = "gruvbox_dark"
}


-- IDE tools config

treesitter.setup {
   ensure_installed = "maintained",
   ignore_install = {  },
   highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
   },
}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    [DocScrollDownKey] = cmp.mapping.scroll_docs(-4),
    [DocScrollUpKey] = cmp.mapping.scroll_docs(4),
    [ExecCompletionKey] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    [CmpScrollUpKey] = cmp.select_next_item(),
    [CmpScrollDownKey] = cmp.select_prev_item(),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
    { name = 'buffer' },
    { name = 'crates' },
  },
}

-- Setup language servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_lsp.update_capabilities(capabilities)
local servers = { "rust_analyzer", "sumneko_lua", "elmls" }
for _,server in ipairs(servers) do
  local server_available, requested_server = lsp_installer_servers.get_server(server)
  if server_available then
    requested_server:on_ready(function ()
      local opts = {
	    capabilities = capabilities,
	  }
       requested_server:setup(opts)
    end)
    if not requested_server:is_installed() then
      -- Queue the server to be installed
      requested_server:install()
    end
end
end

-- Plugin Manager
vim.cmd [[packadd packer.nvim]]
return require('packer').startup(function(use)
  -- Package management
  use {'wbthomason/packer.nvim', opt = true}
  use 'svermeulen/vimpeccable'

  -- Qol
  use {
   'nvim-lualine/lualine.nvim',
   requires = {'kyazdani42/nvim-web-devicons', opt = true}
  }

  use {
   'kyazdani42/nvim-tree.lua',
   requires = 'kyazdani42/nvim-web-devicons',
   config = function() require'nvim-tree'.setup {} end
  }

  -- Libraries
  use 'nvim-lua/plenary.nvim'

  -- Theming
  use 'morhetz/gruvbox'

  -- Sytax Highlighting
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  -- Language Server Features
  use {
   'neovim/nvim-lspconfig',
   'williamboman/nvim-lsp-installer',
   'hrsh7th/nvim-cmp',
   'hrsh7th/cmp-nvim-lsp',
   'hrsh7th/cmp-buffer',
   'hrsh7th/cmp-path',
   'hrsh7th/cmp-cmdline',
   'L3MON4D3/LuaSnip',
   'saadparwaiz1/cmp_luasnip',
  }

  use {
   'simrat39/rust-tools.nvim',
   config = function() rust_tools.setup{} end
  }

  -- Qol Language Features
  use {
    'Saecki/crates.nvim',
    event = { "BufRead Cargo.toml" },
    requires = { { 'nvim-lua/plenary.nvim' } },
    config = function()
    require('crates').setup()
    end,
  }
end)
