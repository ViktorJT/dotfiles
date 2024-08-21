local options = {
  formatters_by_ft = {
    lua = { "stylua" },

    javascript = { { "prettierd", "prettier" } },
    javascriptreact = { { "prettierd", "prettier" } },
    ["javascript.jsx"] = { { "prettierd", "prettier" } },

    typescript = { { "prettierd", "prettier" } },
    typescriptreact = { { "prettierd", "prettier" } },
    ["typescript.tsx"] = { { "prettierd", "prettier" } },

    css = { { "prettierd", "prettier" } },
    html = { { "prettierd", "prettier" } },
    json = { { "prettierd", "prettier" } },
    graphql = { { "prettierd", "prettier" } },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
