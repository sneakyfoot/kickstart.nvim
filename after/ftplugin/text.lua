-- Underline misspelled words. No capitalization check: it flags every
-- lowercase line start, which is mostly noise in notes.
vim.opt_local.spell = true
vim.opt_local.spelllang = 'en_us'
vim.opt_local.spellcapcheck = ''
