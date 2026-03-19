-- ~/.config/nvim/lua/plugins/lsp.lua
-- LSP 配置（使用绝对路径指定虚拟环境）

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          settings = {
            python = {
              pythonPath = "/home/pullautumn/Code/Python/.venv/bin/python",  -- 直接指定虚拟环境的绝对路径
              analysis = {
                extraPaths = { 
                  ".", 
                  "./src",
                  "/home/pullautumn/Code/Python/.venv/lib/python3.12/site-packages"  -- 添加虚拟环境的 site-packages 路径
                },
                typeCheckingMode = "off",  -- 完全关闭类型检查
                -- diagnosticMode = "none",  -- 禁用所有诊断
                -- 禁用所有可能导致问题的检查
                diagnosticSeverityOverrides = {
                  reportMissingImports = "none",
                  reportMissingModuleSource = "none",
                  reportUnknownMemberType = "none",
                  reportUnknownVariableType = "none",
                  reportUnknownArgumentType = "none",
                  reportGeneralTypeIssues = "none",
                  reportOptionalMemberAccess = "none",  -- 不报告可选成员访问（解决 match.group 问题）
                  reportOptionalSubscript = "none",
                  reportOptionalIterable = "none",
                  reportOptionalCall = "none",
                  reportOptionalOperand = "none",
                  reportOptionalContextManager = "none",
                  reportOptionalAttributeAccess = "none",
                },
              },
            },
          },
        },
      },
    },
  },

  -- TypeScript 支持
  { import = "lazyvim.plugins.extras.lang.typescript" },

  -- JSON 支持
  { import = "lazyvim.plugins.extras.lang.json" },

  -- 可选：如果您想用更强大的 Python 扩展（推荐，补全更好）
  { import = "lazyvim.plugins.extras.lang.python" },
}