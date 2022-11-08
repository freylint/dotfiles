
local setup = function()
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

-- Install plugins
require('packer').startup(function(use)
  -- General
  use {
    'wbthomason/packer.nvim',
    'nvim-lua/plenary.nvim'
  }

  -- Aesthetics
  use {
    'Mofiqul/adwaita.nvim',
    'stevearc/dressing.nvim',
    'nvim-lualine/lualine.nvim'
  }

  -- Editor Features
  use {
    'jghauser/mkdir.nvim',
    'takac/vim-hardtime',
    'tpope/vim-fugitive'
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
  use {
    'lewis6991/impatient.nvim',
    config = function()
      require('impatient')
    end
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
    'jose-elias-alvarez/null-ls.nvim',
  }

  use {
    -- TODO configure
    'Saecki/crates.nvim',
    -- TODO configure
    'pianocomposer321/yabs.nvim',
    -- TODO combine with friendly snippets
    'L3MON4D3/LuaSnip',
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)
end

return { setup = setup }
