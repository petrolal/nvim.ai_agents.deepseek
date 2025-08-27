-- Integração Ollama com Neovim
local M = {}

function M.setup()
	local ollama_host = "http://localhost:11434"

	-- Comando para testar conexão
	vim.api.nvim_create_user_command("OllamaPing", function()
		local handle = io.popen("curl -s " .. ollama_host .. "/api/tags")
		local result = handle:read("*a")
		handle:close()

		if result and result ~= "" then
			print("✅ Ollama conectado!")
			vim.print(vim.json.decode(result))
		else
			print("❌ Ollama não está respondendo")
		end
	end, {})

	-- Comando para gerar texto
	vim.api.nvim_create_user_command("OllamaGenerate", function(opts)
		local prompt = table.concat(opts.fargs, " ")
		local json_data = vim.json.encode({
			model = "llama2",
			prompt = prompt,
			stream = false,
		})

		local curl_cmd = string.format("curl -s -X POST %s/api/generate -d '%s'", ollama_host, json_data)

		local handle = io.popen(curl_cmd)
		local result = handle:read("*a")
		handle:close()

		if result then
			local data = vim.json.decode(result)
			if data.response then
				print("🤖 Ollama:")
				print(data.response)
			end
		end
	end, { nargs = "*" })
end

return M
