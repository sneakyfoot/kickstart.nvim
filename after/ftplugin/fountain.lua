-- Screenplays are prose: spellcheck like markdown/text.
vim.opt_local.spell = true
vim.opt_local.spelllang = 'en_us'
vim.opt_local.spellcapcheck = ''

-- Render with `wrap` (installed by ez-nix) to a PDF next to the script.
-- <leader>rp renders and opens it; after that, every save re-renders so the
-- viewer just reloads. <leader>rP is the same with scene numbers.
local buf = vim.api.nvim_get_current_buf()

local function render(opts)
  local src = vim.api.nvim_buf_get_name(buf)
  if src == '' then
    vim.notify('fountain: save the buffer to a file first', vim.log.levels.WARN)
    return
  end
  local pdf = vim.fn.fnamemodify(src, ':r') .. '.pdf'
  local cmd = { 'wrap', 'pdf', src, '-o', pdf }
  if vim.b[buf].fountain_production then table.insert(cmd, '--production') end
  vim.system(cmd, { text = true }, vim.schedule_wrap(function(res)
    if res.code ~= 0 then
      vim.notify('wrap failed:\n' .. (res.stderr or ''), vim.log.levels.ERROR)
    elseif opts.open then
      vim.ui.open(pdf)
    end
  end))
end

local function render_and_open(production)
  vim.b[buf].fountain_production = production
  vim.cmd('silent update')
  render({ open = true })
  vim.api.nvim_create_autocmd('BufWritePost', {
    group = vim.api.nvim_create_augroup('ez-fountain-' .. buf, { clear = true }),
    buffer = buf,
    callback = function() render({ open = false }) end,
  })
end

vim.keymap.set('n', '<leader>rp', function() render_and_open(false) end,
  { buffer = buf, desc = '[R]ender screenplay [P]DF' })
vim.keymap.set('n', '<leader>rP', function() render_and_open(true) end,
  { buffer = buf, desc = '[R]ender [P]roduction PDF (scene numbers)' })
