-- Modern Neovim Configuration with Lazy.nvim
-- Version: 2.1.0

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath})
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function() vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 }) end,
})

require("lazy").setup({
  { "folke/tokyonight.nvim", lazy = false, priority = 1000, config = function()
      require("tokyonight").setup({ style = "storm" })
      vim.cmd.colorscheme("tokyonight")
    end},
  { "nvim-neo-tree/neo-tree.nvim", keys = {{ "<leader>e", ":Neotree toggle<cr>", desc = "Toggle Neo-tree" }},
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        popup_border_style = "rounded",
        enable_git_status = true,
        filesystem = { hijack_netrw_behavior = "open_current" }
      })
    end},
  { "nvim-telescope/telescope.nvim", tag = "0.1.6", dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find Files" },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Live Grep" },
    }},
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "python", "javascript", "typescript", "rust", "go", "bash", "json", "yaml", "toml" },
        sync_install = false, auto_install = true, highlight = { enable = true }, indent = { enable = true },
      })
    end},
  { "neovim/nvim-lspconfig", dependencies = {"williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim"},
    config = function()
      local lsp_servers = { "lua_ls", "pyright", "tsserver", "rust_analyzer", "gopls" }
      require("mason").setup()
      require("mason-lspconfig").setup({ ensure_installed = lsp_servers })
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      for _, server in ipairs(lsp_servers) do
        require("lspconfig")[server].setup({
          capabilities = capabilities,
          on_attach = function(_, bufnr)
            local map = function(keys, func, desc) vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc }) end
            map("gd", vim.lsp.buf.definition, "Go to Definition")
            map("K", vim.lsp.buf.hover, "Hover Documentation")
            map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
          end,
        })
      end
    end},
  { "stevearc/conform.nvim", event = "BufWritePre", config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" }, python = { "ruff_format", "black" }, javascript = { "prettier" }, toml = { "taplo" },
        },
        format_on_save = { timeout_ms = 500, lsp_fallback = true },
      })
    end},
  { "mfussenegger/nvim-lint", event = { "BufReadPre", "BufNewFile" }, config = function()
      local lint = require("lint")
      lint.linters_by_ft = { python = { "ruff" } }
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("nvim-lint-autogroup", { clear = true }),
        callback = function() lint.try_lint() end,
      })
    end},
  { "hrsh7th/nvim-cmp", dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping.select_prev_item(), ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-Space>"] = cmp.mapping.complete(), ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({ { name = "nvim_lsp" }, { name = "luasnip" } }, { { name = "buffer" } }),
      })
    end},
  { "lewis6991/gitsigns.nvim", event = "BufReadPre", config = true },
  { "nvim-lualine/lualine.nvim", config = function() require("lualine").setup({ options = { theme = "tokyonight" }}) end},
  { "akinsho/bufferline.nvim", config = function() require("bufferline").setup({options = {mode = "tabs", separator_style = "slant"}}) end},
  { "akinsho/toggleterm.nvim", keys = { "<c-\>" }, config = function() require("toggleterm").setup({direction = "float", open_mapping = [[<c-\>]]}) end },
  { "folke/which-key.nvim", event = "VeryLazy", config = function() require("which-key").setup() end },
})
