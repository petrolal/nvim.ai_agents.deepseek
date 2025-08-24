local M = {}
local config = require("deepseek-nvim.config").config

-- Função para fazer requisição ao Ollama
local function ask_ollama(prompt, callback)
	local json_body = vim.fn.json_encode({
		model = config.model,
		prompt = prompt,
		stream = false,
	})

	local job = vim.fn.jobstart(
		"curl -s -X POST "
			.. config.url
			.. "/api/generate "
			.. '-H "Content-Type: application/json" '
			.. "-d '"
			.. json_body
			.. "'",
		{
			on_stdout = function(_, data)
				local response = table.concat(data, "")
				if response ~= "" then
					local ok, result = pcall(vim.fn.json_decode, response)
					if ok and result.response then
						callback(result.response)
					else
						callback("Erro na resposta: " .. response)
					end
				end
			end,
			on_stderr = function(_, data)
				callback("Erro: " .. table.concat(data, "\n"))
			end,
		}
	)
end

-- Função para criar janela flutuante
local function create_floating_window()
	local width = math.floor(vim.o.columns * config.float_window.width)
	local height = math.floor(vim.o.lines * config.float_window.height)
	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	local buf = vim.api.nvim_create_buf(false, true)
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal",
		border = config.float_window.border,
	})

	return buf, win
end

-- Comando para perguntar sobre a linha atual
function M.ask_line()
	local line = vim.api.nvim_get_current_line()
	if line == "" then
		return
	end

	local buf, win = create_floating_window()
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Pensando..." })

	ask_ollama("Analise este código: " .. line, function(response)
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(response, "\n", true))
	end)
end

-- Comando para perguntar sobre a seleção visual
function M.ask_selection()
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")
	local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)
	local text = table.concat(lines, "\n")

	local buf, win = create_floating_window()
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Pensando..." })

	ask_ollama("Analise este código:\n" .. text, function(response)
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(response, "\n", true))
	end)
end

-- Comando para chat interativo
function M.chat_window()
	local buf, win = create_floating_window()
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "=== DeepSeek Chat ===", "Digite sua pergunta:" })

	-- Configurar o buffer para chat
	vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
	vim.api.nvim_buf_set_option(buf, "modifiable", true)

	-- Mapear Enter para enviar mensagem
	vim.api.nvim_buf_set_keymap(
		buf,
		"n",
		"<CR>",
		':lua require("deepseek-nvim.commands").send_chat_message()<CR>',
		{ noremap = true }
	)
end

function M.setup()
	-- Criar comandos Vim
	vim.api.nvim_create_user_command("DeepSeekLine", M.ask_line, {})
	vim.api.nvim_create_user_command("DeepSeekSelection", M.ask_selection, {})
	vim.api.nvim_create_user_command("DeepSeekChat", M.chat_window, {})

	-- Mapeamentos de teclas
	local map = vim.keymap.set
	map("n", config.mappings.ask_line, M.ask_line, { desc = "DeepSeek: Perguntar sobre linha" })
	map("v", config.mappings.ask_selection, M.ask_selection, { desc = "DeepSeek: Perguntar sobre seleção" })
	map("n", config.mappings.chat_window, M.chat_window, { desc = "DeepSeek: Abrir chat" })
end

return M
