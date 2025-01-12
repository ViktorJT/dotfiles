return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },

  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = false, -- don't lazy load, necessary for Comment.nvim
    config = require "configs.commentstring",
  },

  {
    "numToStr/Comment.nvim",
    dependencies = "nvim-ts-context-commentstring",
    config = function()
      require("configs.comment").setup()
    end,
  },

  {
    "mfussenegger/nvim-lint",
    opts = require "configs.nvim-lint",
  },

  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    opts = require "configs.nvim-tree",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = require "configs.treesitter",
  },

  {
    "williamboman/mason.nvim",
    opts = require "configs.mason",
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = require "configs.gitsigns",
  },
}
