-- Don't reindent the current line when typing ':' — annoying inside lambdas.
-- Deferred because indent/python.vim runs after this and re-adds '<:>'.
vim.schedule(function()
  vim.opt_local.indentkeys:remove({ '<:>', ':' })
end)
