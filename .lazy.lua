-- Project-local LazyVim overrides for this repo only.
-- Turn off blink.cmp's automatic popups (menu / docs / signature / ghost text).
-- Manual completion still works with <C-Space>.
return {
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        menu = { auto_show = false },
        documentation = { auto_show = false },
        ghost_text = { enabled = false },
      },
      signature = { enabled = false },
    },
  },
  -- Turn off clangd's error/warning highlighting (LSP diagnostics) and inlay hints
  -- for this repo. Toggle diagnostics back on at runtime with: :lua vim.diagnostic.enable()
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
    },
    init = function()
      vim.diagnostic.enable(false)
      vim.lsp.inlay_hint.enable(false)
    end,
  },
}
