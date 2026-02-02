-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  ---@type LazySpec
  {
    'mikavilpas/yazi.nvim',
    version = '*', -- use the latest stable version
    event = 'VeryLazy',
    dependencies = {
      { 'nvim-lua/plenary.nvim', lazy = true },
    },
    keys = {
      -- 👇 in this section, choose your own keymappings!
      {
        '<leader>-',
        mode = { 'n', 'v' },
        '<cmd>Yazi<cr>',
        desc = 'Open yazi at the current file',
      },
      {
        -- Open in the current working directory
        '<leader>cw',
        '<cmd>Yazi cwd<cr>',
        desc = "Open the file manager in nvim's working directory",
      },
      {
        '<c-up>',
        '<cmd>Yazi toggle<cr>',
        desc = 'Resume the last yazi session',
      },
    },
    ---@type YaziConfig | {}
    opts = {
      -- if you want to open yazi instead of netrw, see below for more info
      open_for_directories = false,
      keymaps = {
        show_help = '<f1>',
      },
    },
    -- 👇 if you use `open_for_directories=true`, this is recommended
    init = function()
      -- mark netrw as loaded so it's not loaded at all.
      --
      -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
      vim.g.loaded_netrwPlugin = 1
    end,
  },
  -- {
  --   'NickvanDyke/opencode.nvim',
  --   dependencies = {
  --     -- Recommended for `ask()` and `select()`.
  --     -- Required for `snacks` provider.
  --     ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
  --     { 'folke/snacks.nvim', opts = { input = {}, picker = {}, terminal = {} } },
  --   },
  --   config = function()
  --     ---@type opencode.Opts
  --     vim.g.opencode_opts = {
  --       -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition".
  --     }

  --     -- Required for `opts.events.reload`.
  --     vim.o.autoread = true

  --     -- Recommended/example keymaps.
  --     vim.keymap.set({ 'n', 'x' }, '<C-a>', function()
  --       require('opencode').ask('@this: ', { submit = true })
  --     end, { desc = 'Ask opencode' })
  --     vim.keymap.set({ 'n', 'x' }, '<C-x>', function()
  --       require('opencode').select()
  --     end, { desc = 'Execute opencode action…' })
  --     vim.keymap.set({ 'n', 'x' }, 'ga', function()
  --       require('opencode').prompt '@this'
  --     end, { desc = 'Add to opencode' })
  --     vim.keymap.set({ 'n', 't' }, '<C-.>', function()
  --       require('opencode').toggle()
  --     end, { desc = 'Toggle opencode' })
  --     vim.keymap.set('n', '<S-C-u>', function()
  --       require('opencode').command 'session.half.page.up'
  --     end, { desc = 'opencode half page up' })
  --     vim.keymap.set('n', '<S-C-d>', function()
  --       require('opencode').command 'session.half.page.down'
  --     end, { desc = 'opencode half page down' })
  --     -- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o".
  --     vim.keymap.set('n', '+', '<C-a>', { desc = 'Increment', noremap = true })
  --     vim.keymap.set('n', '-', '<C-x>', { desc = 'Decrement', noremap = true })
  --   end,
  -- },
  -- {
  --   'github/copilot.vim',
  --   -- event = 'InsertEnter',
  --   -- init = function()
  --   --   -- Keep <Tab> free; use explicit mappings.
  --   --   vim.g.copilot_no_tab_map = true

  --   --   -- Accept suggestion.
  --   --   vim.keymap.set('i', '<C-l>', 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false })

  --   --   -- Navigate / dismiss suggestions.
  --   --   vim.keymap.set('i', '<C-]>', '<Plug>(copilot-next)', { silent = true })
  --   --   vim.keymap.set('i', '<C-[>', '<Plug>(copilot-previous)', { silent = true })
  --   --   vim.keymap.set('i', '<C-\\>', '<Plug>(copilot-dismiss)', { silent = true })
  --   -- end,
  -- },
  {
    'TabbyML/vim-tabby',
    url = 'https://github.com/ppmzhang2/vim-tabby',
    commit = '6ee6dd5',
    lazy = false,
    dependencies = {
      'neovim/nvim-lspconfig',
    },
    init = function()
      vim.g.tabby_agent_start_command = { 'npx', 'tabby-agent', '--stdio' }
      vim.g.tabby_inline_completion_trigger = 'auto'
      vim.g.tabby_inline_completion_keybinding_accept = "<C-'>"
    end,
  },
  {
    'chrisgrieser/nvim-origami',
    event = 'VeryLazy',
    opts = {}, -- needed even when using default config

    -- recommended: disable vim's auto-folding
    init = function()
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
    end,
  },
}
