local setup = function()
  require("mason").setup()
  require("mason-lspconfig").setup({
    ensure_installed = {"sumneko_lua", "rust_analyzer"}
  })


  local null_ls = require("null-ls")
  null_ls.setup({
    sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.completion.spell,
    },
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
end

return { setup = setup }
