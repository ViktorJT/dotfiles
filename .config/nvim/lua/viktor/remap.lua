-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- CAPS-LOCK is mapped to ESC in OS (Preferences -> Keyboard -> Modifier Keys)

vim.keymap.set('i', '<C-b>', "<ESC>^i", { desc = "Beginning of line" })
vim.keymap.set('i', '<C-e>', "<End>", { desc = "End of line" })

vim.keymap.set('n', '<esc>', "<cmd> noh <CR>", { desc = "End of line" })

-- Navigate within insert mode
vim.keymap.set('i', '<C-h>', "<Left>", { desc = "Move left within insert mode" })
vim.keymap.set('i', '<C-l>', "<Right>", { desc = "Move right within insert mode" })
vim.keymap.set('i', '<C-j>', "<Down>", { desc = "Move down within insert mode" })
vim.keymap.set('i', '<C-k>', "<Up>", { desc = "Move up within insert mode" })

-- Split windows
vim.keymap.set('n', '<C-v>', "<cmd> vsplit <CR>", { desc = "Vertically split window" })

-- Navigate between windows
vim.keymap.set('n', '<C-h>', "<C-w>h", { desc = "Move to left window" })
vim.keymap.set('n', '<C-l>', "<C-w>l", { desc = "Move to right window" })
vim.keymap.set('n', '<C-j>', "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set('n', '<C-k>', "<C-w>k", { desc = "Move to top window" })

vim.keymap.set('n', '<C-x>', "<cmd> x <CR>", { desc = "Close window" })
vim.keymap.set('n', '<C-q>', "<cmd> wqa <CR>", { desc = "Save and quit" })

vim.keymap.set('n', '<C-s>', '<cmd> w <CR>', { desc = "Save file" })

vim.keymap.set('n', '<C-c>', '<cmd> %y+ <CR>', { desc = "Copy whole file" })

-- Open default Netrw file explorer
-- vim.keymap.set("n", "<leader>fe", vim.cmd.Ex)

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', '<Up>', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', '<Down>', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('v', '<Up>', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('v', '<Down>', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('x', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('x', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Enable moving lines in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Center cursor when half-page jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Center cursor when searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Don't replace paste registry when overriding
vim.keymap.set("x", "p", 'p:let @+=@0<CR>:let @"=@0<CR>', { silent = true })

-- Quickfix list commands
-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Substitute current word in file
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
