local setup = function()
  local maps = require('keymap')

  require("mason").setup()
  require("mason-lspconfig").setup({
    ensure_installed = {"sumneko_lua", "rust_analyzer"}
  })


  local null_ls = require("null-ls")
  null_ls.setup({
    sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.completion.spell,
    },
  })

  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  require("lspconfig").sumneko_lua.setup({
    capabilities = capabilities,
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
    capabilities = capabilities,
  })

  -- TODO use ansible-lint from mason install
  require("lspconfig").ansiblels.setup({
    capabilities = capabilities,
  })

  local luasnip = require("luasnip")
  require("cmp").setup({
    snippet = {
      example = function(args)
        luasnip.lsp_expand(args.body)
      end
    },
    mapping = maps.cmp_map,
    sources = {
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
    },
  })
end

return { setup = setup }
