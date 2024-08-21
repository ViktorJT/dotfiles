local opts = {
  events = { "BufWritePost", "BufReadPost", "InsertLeave" },
  linters_by_ft = {
    javascript = {
      "eslint_d",
      "eslint",
    },
    javascriptreact = {
      "eslint_d",
      "eslint",
    },
    ["javascript.jsx"] = {
      "eslint_d",
      "eslint",
    },

    typescript = {
      "eslint_d",
      "eslint",
    },
    typescriptreact = {
      "eslint_d",
      "eslint",
    },
    ["typescript.tsx"] = {
      "eslint_d",
      "eslint",
    },
  },
}

return opts
-- local lint = require "lint"
-- local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
--
-- vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
--   group = lint_augroup,
--   callback = function()
--     lint.try_lint()
--   end,
-- })
