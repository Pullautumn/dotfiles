return {
  "numToStr/Comment.nvim",
  event = "VeryLazy",
  opts = {
    -- 基本配置（默认已支持所有语言，无需手动 configure）
    toggler = {
      line = "gcc",  -- 正常模式下注释当前行
      block = "gbc", -- 正常模式下块注释
    },
    opleader = {
      line = "gc",   -- 视觉模式下注释选中行
      block = "gb",  -- 视觉模式下块注释
    },
    extra = {
      above = "gcO", -- 在上方添加注释行
      below = "gco", -- 在下方添加注释行
      eol = "gcA",   -- 在行尾添加注释
    },
  },
}