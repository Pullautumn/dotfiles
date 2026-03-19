-- ~/.config/nvim/lua/plugins/editor.lua
-- 编辑器增强插件

return {
  -- Telescope 文件查找器配置
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- 添加查找插件文件的快捷键
      {
        "<leader>fp",
        function()
          require("telescope.builtin").find_files({
            cwd = require("lazy.core.config").options.root
          })
        end,
        desc = "查找插件文件",
      },
    },
    -- 修改 Telescope 选项
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },

  -- Trouble 诊断窗口（已禁用示例）
  -- 如果要启用，删除 enabled = false
  {
    "folke/trouble.nvim",
    enabled = false, -- 设置为 true 启用
    opts = {
      use_diagnostic_signs = true
    },
  },
}