local options = {
  formatters_by_ft = {
    lua = { "stylua" },

    vue = {
      "eslint_d", -- Necessary for Planhat setup
      "prettierd",
      "prettier",
      stop_after_first = true,
    },

    javascript = {
      "eslint_d", -- Necessary for Planhat setup
      "prettierd",
      "prettier",
      stop_after_first = true,
    },
    javascriptreact = {
      "eslint_d", -- Necessary for Planhat setup
      "prettierd",
      "prettier",
      stop_after_first = true,
    },
    ["javascript.jsx"] = {
      "eslint_d", -- Necessary for Planhat setup
      "prettierd",
      "prettier",
      stop_after_first = true,
    },

    typescript = {
      "eslint_d", -- Necessary for Planhat setup
      "prettierd",
      "prettier",
      stop_after_first = true,
    },
    typescriptreact = {
      "eslint_d", -- Necessary for Planhat setup
      "prettierd",
      "prettier",
      stop_after_first = true,
    },
    ["typescript.tsx"] = {
      "eslint_d", -- Necessary for Planhat setup
      "prettierd",
      "prettier",
      stop_after_first = true,
    },

    css = { "prettierd", "prettier", stop_after_first = true },
    html = { "prettierd", "prettier", stop_after_first = true },
    json = { "prettierd", "prettier", stop_after_first = true },
    graphql = { "prettierd", "prettier", stop_after_first = true },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
