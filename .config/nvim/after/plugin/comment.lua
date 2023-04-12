require('Comment').setup({
   pre_hook = function(ctx)
      return require('Comment.jsx').calculate(ctx);
   end
})

vim.keymap.set("n", "<leader>/", function()
   require("Comment.api").toggle.linewise.current()
 end, { desc = "toggle comment in normal mode", silent = true })

vim.keymap.set("v", "<leader>/", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", { desc = "toggle comment in visual mode", silent = true })
