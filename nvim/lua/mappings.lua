require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })

map("n", "<leader>x", ":close<CR>", { desc = "Close window" })

map("n", "<leader>v", ":vsplit<CR>", { desc = "Split window vertically" })
map("n", "<leader>h", ":split<CR>", { desc = "Split window horizontally" })

map("n", "<C-d>", "<C-d>zz", { desc = "Move down half-page" })
map("n", "<C-u>", "<C-u>zz", { desc = "Move up half-page" })

map("i", "jk", "<ESC>")
map("i", "<C-s>", "<Esc>:w<CR>", { desc = "Save file in insert mode" })

map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

