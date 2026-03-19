-- ~/.config/nvim/lua/plugins/treesitter.lua
-- Treesitter 语法高亮配置

return {
  -- Treesitter 配置（方式一：完全覆盖）
  -- 注意：这会完全替换 ensure_installed 列表
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
    },
  },

  -- Treesitter Context 插件配置
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      enable = true, -- 启用插件
      throttle = true, -- 节流更新
      max_lines = 3, -- 上下文最大行数
    },
    config = function (_, opts)
      require("treesitter-context").setup(opts)
    end
  },

  -- Treesitter 配置（方式二：扩展默认配置）
  -- 推荐使用这种方式，它会在默认列表基础上添加
  -- 如果使用这个，注释掉上面的配置
  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   opts = function(_, opts)
  --     vim.list_extend(opts.ensure_installed, {
  --       "tsx",
  --       "typescript",
  --       "python",
  --       "lua",
  --       -- 在这里添加更多语言
  --     })
  --   end,
  -- },
}