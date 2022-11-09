-- Plugin and Vim keymap configraiton

-- General keymap
local builtin = require('telescope.builtin')
local telescope = require('telescope')
local wk_map = {
  g = {
    D = {vim.lsp.buf.declaration, "-> Decl"},
    d = {vim.lsp.buf.definition, "-> Def"},
    i = {vim.lsp.buf.implementation, "-> Impl"},
  },
  -- Make enter play nicely with completion
  ["<leader>"] = {
    r = {
      name = "+refactor",
      r = {vim.lsp.buf.rename, "rename"},
    },
    f = {
      name = "+file",
      e = {telescope.extensions.file_browser.file_browser, "file browser"},
      g = {builtin.live_grep, "live grep"},
      b = {builtin.buffers, "find buffer"},
      h = {builtin.help_tags, "find help tags"},
    },
  },
}


-- Completion keymap
local cmp = require('cmp')
local luasnip = require('luasnip')
local cmp_map = cmp.mapping.preset.insert({
  ['<C-d>'] = cmp.mapping.scroll_docs(-4),
  ['<C-f>'] = cmp.mapping.scroll_docs(4),
  ['<C-Space>'] = cmp.mapping.complete(),
  ['<CR>'] = cmp.mapping.confirm {
    behavior = cmp.ConfirmBehavior.Replace,
    select = true,
  },
  ['<Tab>'] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    elseif luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
    else
      fallback()
    end
  end, { 'i', 's' }),
  ['<S-Tab>'] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    elseif luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      fallback()
    end
  end, { 'i', 's' }),
})



local setup = function()

  local wk = require('which-key')
  wk.setup {}

  -- Setup space as leader key
  vim.keymap.set("n", "<space>", "",{ silent = true, remap = false })
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ','

  -- Setup LSP keybindings
  wk.register({wk_map, {}})

end

return { setup = setup, cmp_map = cmp_map }
