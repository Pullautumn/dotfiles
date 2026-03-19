return {
  "supermaven-inc/supermaven-nvim",
  event = "VeryLazy",
  config = function()
    require("supermaven-nvim").setup({
      keymaps = {
        accept_suggestion = "<Tab>",  -- 接受建议
        clear_suggestion = "<C-]>",   -- 清除建议
        accept_word = "<C-w>",         -- 接受单词
      },
      ignore_filetypes = {
        -- 忽略的文件类型
        "TelescopePrompt",
        "NvimTree",
        "alpha",
        "dashboard",
        "neo-tree",
        "Outline",
        "toggleterm",
        "lazy",
        "mason",
        "notify",
        "noice",
        "dapui",
        "dap-repl",
      },
      disable_inline_completion = false,  -- 启用内联补全
      disable_keymaps = false,             -- 启用默认键位映射
      color = {
        suggestion_color = "#888888",      -- 建议文本颜色
        cterm = 244,                       -- 终端颜色
      },
      log_level = "info",                  -- 日志级别: "trace", "debug", "info", "warn", "error"
      disable_inline_completion = vim.fn.has("nvim-0.9.0") == 0,  -- 对于旧版本禁用内联补全
    })
  end,
}