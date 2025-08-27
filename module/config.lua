local M = {}

M.config = {
	model = "deepseek-coder", -- Modelo padrão
	url = "http://localhost:11434", -- URL do Ollama
	timeout = 30000, -- timeout em ms
	-- Configurações de UI
	float_window = {
		width = 0.8,
		height = 0.7,
		border = "rounded",
	},
	-- Mapeamentos padrão
	mappings = {
		ask_line = "<leader>as",
		ask_selection = "<leader>as",
		ask_buffer = "<leader>ab",
		chat_window = "<leader>ac",
	},
}

return M
