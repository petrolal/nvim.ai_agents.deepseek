-- Configuração Ollama
require("ollama-nvim-integration").setup()

-- Mapeamentos
vim.keymap.set("n", "<leader>op", ":OllamaPing<CR>", { desc = "Testar conexão Ollama" })
vim.keymap.set("v", "<leader>og", ":OllamaGenerate<CR>", { desc = "Gerar texto com Ollama" })
