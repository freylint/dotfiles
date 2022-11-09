local setup = function()

  -- Dont run treesitter on files >100 KB
  require'nvim-treesitter.configs'.setup({
    auto_install = true,
    highlight = {
    disable = function(_lang, buf)
      local max_filesize = 100 * 1024
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end
    }
  })

  -- Set up editor features
  require('nvim-web-devicons').setup()
  require('guess-indent').setup {}
  require('dressing').setup ()
  require('impatient')
  require("better-escape").setup()
  -- TODO integrate with keymap file
  require('leap').add_default_mappings()

  require('lualine').setup({
    options = {
      theme = 'adwaita',
    }
  })
  end

  -- Setup telescope extensions
  require("telescope").load_extension "file_browser"

  -- Format on save
  vim.cmd([[
    augroup FormatAutogroup
      autocmd!
      autocmd BufWritePost * FormatWrite
    augroup END
  ]])

return { setup = setup }
