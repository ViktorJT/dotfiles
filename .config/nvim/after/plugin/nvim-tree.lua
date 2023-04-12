require('nvim-tree').setup()

vim.keymap.set("n", "<leader>fe", vim.cmd.NvimTreeToggle, { desc =  "[F]ile [E]xplorer" })
