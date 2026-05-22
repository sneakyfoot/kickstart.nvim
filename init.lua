-- Neovim 0.12 minimal config
-- Uses built-in vim.pack for plugins, built-in vim.lsp.config for LSP.

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = false

-- ============================================================================
-- Options
-- ============================================================================

local o, opt = vim.o, vim.opt

o.number = true
o.mouse = 'a'
o.showmode = false
o.breakindent = true
o.undofile = true
o.ignorecase = true
o.smartcase = true
o.signcolumn = 'yes'
o.updatetime = 250
o.timeoutlen = 300
o.splitright = true
o.splitbelow = true
o.list = true
o.inccommand = 'split'
o.cursorline = true
o.scrolloff = 10
o.confirm = true
o.wrap = true
o.linebreak = true
o.breakat = ' \t;:,!?'
o.foldlevel = 99
o.foldlevelstart = 99
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.schedule(function()
  o.clipboard = 'unnamedplus'
end)

-- ============================================================================
-- Keymaps (non-LSP — LSP keymaps below in LspAttach)
-- ============================================================================

local map = vim.keymap.set

map('n', '<Esc>', '<cmd>nohlsearch<CR>')
map('n', '<leader>pv', vim.cmd.Ex)
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic quickfix list' })
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Focus left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Focus right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Focus lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Focus upper window' })

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('ez-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- ============================================================================
-- Plugins (vim.pack)
-- ============================================================================

vim.pack.add({
  -- Colorscheme
  { src = 'https://github.com/Mofiqul/dracula.nvim' },

  -- LSP defaults
  { src = 'https://github.com/neovim/nvim-lspconfig' },

  -- Treesitter (community fork — original nvim-treesitter is archived)
  { src = 'https://github.com/neovim-treesitter/nvim-treesitter' },
  { src = 'https://github.com/neovim-treesitter/treesitter-parser-registry' },

  -- Completion
  { src = 'https://github.com/Saghen/blink.cmp', version = vim.version.range('1.*') },

  -- Fuzzy finder
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/nvim-telescope/telescope.nvim' },
  { src = 'https://github.com/nvim-telescope/telescope-ui-select.nvim' },

  -- Files / git
  { src = 'https://github.com/mikavilpas/yazi.nvim' },
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },

  -- Mini suite (statusline, textobjects, surround)
  { src = 'https://github.com/nvim-mini/mini.nvim' },

  -- Formatting
  { src = 'https://github.com/stevearc/conform.nvim' },

  -- Folding
  { src = 'https://github.com/chrisgrieser/nvim-origami' },

  -- Lua dev: types for vim.* APIs when editing config
  { src = 'https://github.com/folke/lazydev.nvim' },
})

-- ============================================================================
-- Colorscheme
-- ============================================================================

require('dracula').setup({
  transparent_bg = true,
  colors = {
    bg = '#22212C',
    fg = '#F8F8F2',
    selection = '#454158',
    comment = '#7970A9',
    cyan = '#80FFEA',
    green = '#8AFF80',
    orange = '#FFCA80',
    pink = '#FF80BF',
    purple = '#9580FF',
    red = '#FF9580',
    yellow = '#FFFF80',
  },
  styles = { comments = { italic = false } },
})
vim.cmd.colorscheme('dracula')

-- ============================================================================
-- Treesitter (new API — handles parser install only; we enable per filetype)
-- ============================================================================

local ensure_parsers = {
  'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline',
  'nix', 'python', 'query', 'rust', 'vim', 'vimdoc',
}

local ts_ok, ts = pcall(require, 'nvim-treesitter')
if ts_ok then
  ts.setup({ install_dir = vim.fn.stdpath('data') .. '/site' })
  local installed = require('nvim-treesitter.config').get_installed()
  local to_install = vim.iter(ensure_parsers)
    :filter(function(p) return not vim.tbl_contains(installed, p) end)
    :totable()
  if #to_install > 0 then
    ts.install(to_install)
  end

  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('ez-treesitter', { clear = true }),
    callback = function()
      pcall(vim.treesitter.start)
      pcall(function()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end)
    end,
  })
end

-- ============================================================================
-- LSP
-- ============================================================================

vim.diagnostic.config({
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  virtual_text = { source = 'if_many', spacing = 2 },
})

-- lazydev: completion + types for the nvim Lua API when editing config files
require('lazydev').setup({
  library = { { path = '${3rd}/luv/library', words = { 'vim%.uv' } } },
})

-- Per-server configs (override nvim-lspconfig defaults)
vim.lsp.config('nixd', {
  cmd = { 'nixd' },
  filetypes = { 'nix' },
})

vim.lsp.config('rust_analyzer', {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  settings = {
    ['rust-analyzer'] = {
      cargo = { buildScripts = { enable = true } },
      procMacro = { enable = true },
    },
  },
})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      completion = { callSnippet = 'Replace' },
    },
  },
})

vim.lsp.config('ty', {
  cmd = { 'ty', 'server' },
  filetypes = { 'python' },
})

vim.lsp.config('ruff', {
  cmd = { 'ruff', 'server' },
  filetypes = { 'python' },
  init_options = { settings = { args = {} } },
})

-- Enable per-server: skip lua_ls if not installed (NixOS may not have it)
local servers = { 'nixd', 'rust_analyzer', 'ty', 'ruff' }
if vim.fn.executable('lua-language-server') == 1 then
  table.insert(servers, 'lua_ls')
end
vim.lsp.enable(servers)

-- LspAttach: extra keymaps + cursor highlight. 0.12 already provides defaults
-- for grn, gra, grr, gri, grt, gO, K, <C-s>.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('ez-lsp', { clear = true }),
  callback = function(event)
    local bufmap = function(keys, fn, desc)
      map('n', keys, fn, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end
    bufmap('grd', vim.lsp.buf.definition, 'Goto definition')
    bufmap('grD', vim.lsp.buf.declaration, 'Goto declaration')
    bufmap('<leader>th', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
    end, 'Toggle inlay hints')

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
      local hl_group = vim.api.nvim_create_augroup('ez-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf, group = hl_group, callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf, group = hl_group, callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

-- ============================================================================
-- Completion (blink.cmp)
-- ============================================================================

require('blink.cmp').setup({
  keymap = { preset = 'default' },
  appearance = { nerd_font_variant = 'mono' },
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 250 },
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'lazydev' },
    providers = {
      lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
    },
  },
  snippets = { preset = 'default' },
  fuzzy = { implementation = 'lua' },
  signature = { enabled = true },
})

-- ============================================================================
-- Telescope
-- ============================================================================

require('telescope').setup({
  extensions = {
    ['ui-select'] = { require('telescope.themes').get_dropdown() },
  },
})
pcall(require('telescope').load_extension, 'ui-select')

local tb = require('telescope.builtin')
map('n', '<leader>sh', tb.help_tags, { desc = '[S]earch [H]elp' })
map('n', '<leader>sk', tb.keymaps, { desc = '[S]earch [K]eymaps' })
map('n', '<leader>sf', tb.find_files, { desc = '[S]earch [F]iles' })
map('n', '<leader>sw', tb.grep_string, { desc = '[S]earch current [W]ord' })
map('n', '<leader>sg', tb.live_grep, { desc = '[S]earch by [G]rep' })
map('n', '<leader>sd', tb.diagnostics, { desc = '[S]earch [D]iagnostics' })
map('n', '<leader>sr', tb.resume, { desc = '[S]earch [R]esume' })
map('n', '<leader>s.', tb.oldfiles, { desc = '[S]earch recent files' })
map('n', '<leader><leader>', tb.buffers, { desc = 'Find buffers' })
map('n', '<leader>/', function()
  tb.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
    winblend = 10, previewer = false,
  }))
end, { desc = 'Fuzzy find in buffer' })
map('n', '<leader>sn', function()
  tb.find_files({ cwd = vim.fn.stdpath('config') })
end, { desc = '[S]earch [N]eovim config' })

-- ============================================================================
-- Mini suite
-- ============================================================================

require('mini.ai').setup({ n_lines = 500 })
require('mini.surround').setup()
local statusline = require('mini.statusline')
statusline.setup({ use_icons = vim.g.have_nerd_font })
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function() return '%2l:%-2v' end

-- ============================================================================
-- Gitsigns
-- ============================================================================

require('gitsigns').setup({
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
})

-- ============================================================================
-- Conform (format on save)
-- ============================================================================

require('conform').setup({
  notify_on_error = false,
  format_on_save = function(bufnr)
    local disable = { c = true, cpp = true }
    if disable[vim.bo[bufnr].filetype] then return nil end
    return { timeout_ms = 500, lsp_format = 'fallback' }
  end,
  formatters_by_ft = {
    lua = { 'stylua' },
    python = { 'ruff_format', 'ruff_organize_imports' },
  },
})
map('', '<leader>f', function()
  require('conform').format({ async = true, lsp_format = 'fallback' })
end, { desc = '[F]ormat buffer' })

-- ============================================================================
-- Yazi
-- ============================================================================

vim.g.loaded_netrwPlugin = 1
require('yazi').setup({
  open_for_directories = false,
  keymaps = { show_help = '<f1>' },
})
map({ 'n', 'v' }, '<leader>-', '<cmd>Yazi<cr>', { desc = 'Open yazi at current file' })
map('n', '<leader>cw', '<cmd>Yazi cwd<cr>', { desc = 'Open yazi at cwd' })
map('n', '<c-up>', '<cmd>Yazi toggle<cr>', { desc = 'Resume last yazi' })

-- ============================================================================
-- Origami (folding)
-- ============================================================================

require('origami').setup({
  useLspFoldsWithTreesitterFallback = {
    enabled = true,
    foldmethodIfNeitherIsAvailable = 'indent',
  },
  pauseFoldsOnSearch = true,
  foldtext = {
    enabled = true,
    padding = { width = 3 },
    lineCount = { template = 'Folded %d lines', hlgroup = 'Comment' },
    diagnosticsCount = true,
    gitsignsCount = true,
  },
  autoFold = { enabled = false },
  foldKeymaps = { setup = true },
})
