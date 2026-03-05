-- Set .env files and variants to "dotenv" filetype
vim.filetype.add({
  pattern = {
    ["%.env.*"] = "dotenv",
    ["%.env.*.example"] = { "conf", { priority = 1 } }, -- Treat .env.example differently
  },
})

-- Register the "bash" Treesitter language for "dotenv" to enable syntax highlighting
vim.treesitter.language.register("bash", "dotenv")
