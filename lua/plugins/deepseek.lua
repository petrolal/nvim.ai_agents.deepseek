-- ~/.config/nvim/lua/plugins/deepseek.lua

return {
  -- Nosso plugin personalizado DeepSeek
  {
    dir = vim.fn.stdpath("config") .. "/lua/deepseek-nvim",
    config = function()
      require("deepseek-nvim").setup({
        model = "deepseek-coder",
        url = "http://localhost:11434",
        timeout = 30000,
        mappings = {
          ask_line = "<leader>di",
          ask_selection = "<leader>ds",
          chat_window = "<leader>dc",
          explain_code = "<leader>de",
          refactor_code = "<leader>dr",
        },
        float_window = {
          width = 0.8,
          height = 0.7,
          border = "rounded",
        },
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    event = "VeryLazy",
  },
}
