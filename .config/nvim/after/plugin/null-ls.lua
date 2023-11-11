local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

local lsp_formatting = function(buffer)
  vim.lsp.buf.format({
    filter = function(client)
      -- By default, ignore any formatters provider by other LSPs 
      -- (such as those managed via lspconfig or mason)
      -- Also "eslint as a formatter" doesn't work :(
      return client.name == "null-ls"
    end,
    bufnr = buffer,
  })
end

-- Format on save
-- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Avoiding-LSP-formatting-conflicts#neovim-08
local on_attach = function(client, buffer)
  -- the Buffer will be null in buffers like nvim-tree or new unsaved files
  if (not buffer) then
    return
  end

  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = buffer })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = buffer,
      callback = function()
        lsp_formatting(buffer)
      end,
    })
  end
end

null_ls.setup({
	debug = false,
	sources = {
		formatting.prettierd,
		-- formatting.stylua,
		-- diagnostics.eslint_d,
		-- diagnostics.eslint,
	},
	on_attach = on_attach
})
