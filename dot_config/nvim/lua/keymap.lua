local setup = function()

  local wk = require('which-key')
  wk.setup {}

  -- Setup space as leader key
  vim.keymap.set("n", "<space>", "",{ silent = true, remap = false })
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ','

  -- Setup LSP keybindings
  wk.register({
    g = {
      D = {vim.lsp.buf.declaration, "-> Decl"},
      d = {vim.lsp.buf.definition, "-> Def"},
      i = {vim.lsp.buf.implementation, "-> Impl"},
    },
    ["<leader>"] = {
      r = {
        name = "+refactor",
        r = {vim.lsp.buf.rename, "rename"},
      },
      f = {
        name = "+file",
        e = {"<cmd>Explore<cr>", "explore"},
      },
    },
    }, {
    -- Use defaults
    })

end

return { setup = setup }
