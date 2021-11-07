-- General
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true

vim.o.hidden = true

vim.o.history = 256

vim.o.tabstop = 4
vim.o.completeopt = 'menu,menuone,noselect'
vim.o.shiftwidth = vim.o.tabstop


-- Keymap
local vimp = require('vimp')


-- Set colorscheme
vim.cmd('colorscheme gruvbox')


-- Treesitter config
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = { "javascript" }, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

-- Setup language servers
local lsp_installer_servers = require'nvim-lsp-installer.servers'
local cmp = require 'cmp'
local luasnip = require 'luasnip'

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Completion Configuratoin
cmp.setup {
  snippet = {
    expand = function(args)
		require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
	{ name = 'buffer' },
	{ name = 'crates' },
  },
}

-- Lua Semenko language server config
local server_available, requested_server = lsp_installer_servers.get_server("rust_analyzer")
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

-- Rust Analyzer language server config
local server_available, requested_server = lsp_installer_servers.get_server("semenko_lua")
if server_available then
	require('rust-tools').setup({})
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

-- Plugin Manager
vim.cmd [[packadd packer.nvim]]
return require('packer').startup(function(use)
  -- Package management
  use {'wbthomason/packer.nvim', opt = true}
  use 'svermeulen/vimpeccable'

  -- Libraries
  use 'nvim-lua/plenary.nvim'

  -- Theming
  use 'morhetz/gruvbox'

  -- Sytax Highlighting
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  -- Project exploring
  use {
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function() require'nvim-tree'.setup {} end
  }

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
	'simrat39/rust-tools.nvim'
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
end
)

