local options = {
  formatters_by_ft = {
    lua = { "stylua" },

    vue = { "prettierd", "prettier", stop_after_first = true },

    javascript = { "prettierd", "prettier", stop_after_first = true },
    javascriptreact = { "prettierd", "prettier", stop_after_first = true },
    ["javascript.jsx"] = { "prettierd", "prettier", stop_after_first = true },

    typescript = { "prettierd", "prettier", stop_after_first = true },
    typescriptreact = { "prettierd", "prettier", stop_after_first = true },
    ["typescript.tsx"] = { "prettierd", "prettier", stop_after_first = true },

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
