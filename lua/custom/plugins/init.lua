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
  --   'TabbyML/vim-tabby',
  --   url = 'https://github.com/ppmzhang2/vim-tabby',
  --   commit = '6ee6dd5',
  --   lazy = false,
  --   dependencies = {
  --     'neovim/nvim-lspconfig',
  --   },
  --   init = function()
  --     vim.g.tabby_agent_start_command = { 'npx', 'tabby-agent', '--stdio' }
  --     vim.g.tabby_inline_completion_trigger = 'auto'
  --     vim.g.tabby_inline_completion_keybinding_accept = '<C-a>'
  --   end,
  -- },
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
