" Plugins
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')
	Plug 'tpope/vim-sensible'

	Plug 'agude/vim-eldar'

	Plug 'neovim/nvim-lspconfig', {'do': './setup/lsp-sh.sh'}
call plug#end()

" User Config
set number
if has('syntax')
    syntax enable             " Turn on syntax highlighting
    silent! colorscheme eldar " Custom color scheme
endif

" LSP Configuration
lua << EOF
local nvim_lsp = require('lspconfig')

-- FIXME hardcoded config path
local nvim_cfg_dir = '/home/gen/.config/nvim'

-- Function for global lsp configuration on attachment of the server
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local opts = { noremap=true, silent=true }

  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- Shell LSP setup
require'lspconfig'.bashls.setup{}

-- Lua LSP setup
local os_name
if vim.fn.has("mac") == 1 then
  os_name = "macOS"
elseif vim.fn.has("unix") == 1 then
  os_name = "Linux"
elseif vim.fn.has('win32') == 1 then
  os_name = "Windows"
else
  print("Unsupported system for sumneko")
end

local sumneko_root_path = nvim_cfg_dir..'/build/lua-language-server'
local sumneko_binary = sumneko_root_path.."/bin/"..os_name.."/lua-language-server"

nvim_lsp.sumneko_lua.setup{
  filetypes = { 'lua' };
  log_level = 2;
  cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
  settings = {
    Lua = {
      runtime = {
        version = 'Lua 5.4',
        path = {
          '?.lua',
          '?/init.lua',
          '/usr/share/5.4/?.lua',
          '/usr/share/lua/5.4/?/init.lua'
        }
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
        -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    }
  }
}

-- Rust LSP Setup
nvim_lsp.rust_analyzer.setup{}

EOF
