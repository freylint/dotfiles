-- Nvim configuration
vim.opt.number = true

require("mason").setup()
require("mason-lspconfig").setup()
require("mason-lspconfig").setup_handlers {
  -- Default
  function (server_name)
    require("lspconfig")[server_name].setup {}
    require('guess-indent').setup {}
  end,
  -- Rust
  ["rust_analyzer"] = function ()
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


return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig',
    'neovim/nvim-lspconfig',
    'simrat39/rust-tools.nvim',
    'mfussenegger/nvim-dap'
  }

  use 'nvim-lua/plenary.nvim'

  use 'nmac427/guess-indent.nvim'
end)

