local M = {}

local config = require("deepseek-nvim.config")
local commands = require("deepseek-nvim.commands")

function M.setup(user_config)
	-- Merge configurações
	config = vim.tbl_deep_extend("force", config, user_config or {})
	-- Configurar comandos e mapeamentos
	commands.setup()

	-- Pring Model Loading
	print("DeepSeek NVIM carregado! Modelo: " .. config.model)
end

return M
