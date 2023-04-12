-- [[ Setting options ]]
-- See `:help vim.o`

-- Disable netrw at the very start of your init.lua (strongly advised for nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1


-- Enable mouse mode
vim.o.mouse = 'a'

-- Set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- Line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Indenting
vim.o.breakindent = true -- Enable break indent
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = true -- Disable line wrapping

-- Backups
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Searching
vim.o.hlsearch = true -- Set highlight on search
vim.opt.incsearch = true -- Incremental search highlighting

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 100

vim.wo.signcolumn = 'yes' -- enable sign column

-- vim.opt.colorcolumn = '80' -- enable line length column indicator

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

vim.opt.scrolloff = 8 -- Set padding when scrolling

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
