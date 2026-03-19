-- ~/.config/nvim/lua/plugins/mason.lua
-- 开发工具配置

return {
  -- Mason 工具管理器
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",      -- Lua 格式化
        "shellcheck",  -- Shell 脚本检查
        "shfmt",       -- Shell 格式化
        "flake8",      -- Python 代码检查
        "eslint_d",    -- JavaScript 检查
        "prettier",    -- 前端格式化
        "typescript-language-server", -- TypeScript 语言服务器
        "pyright",     -- Python 语言服务器
        "black",       -- Python 格式化工具
        "isort",       -- Python 导入排序
      },
    },
  },
}