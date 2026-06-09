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
}
