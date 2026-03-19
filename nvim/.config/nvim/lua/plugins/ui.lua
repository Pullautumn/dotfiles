-- ~/.config/nvim/lua/plugins/ui.lua
-- UI 相关插件配置

return {
  -- Lualine 状态栏配置（方式一：扩展配置）
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      -- 在状态栏右侧添加一个笑脸
      table.insert(opts.sections.lualine_x, {
        function()
          return "😄"
        end,
      })
    end,
  },
}