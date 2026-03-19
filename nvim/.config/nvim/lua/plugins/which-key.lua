return {
  "folke/which-key.nvim",
  opts = {
    win = {
      border = "rounded",
    },
    spec = {
      -- 按字母顺序排列的 leader 组
      -- {
      --   "<leader>a",
      --   group = "🤖 AI 辅助",
      -- },
      -- {
      --   "<leader>as",
      --   group = "🚀 Supermaven",
      -- },
      {
        "<leader>b",
        group = "🗔 缓冲区管理",
      },
      -- {
      --   "<leader>D",
      --   group = "🔄 差异对比",
      -- },
      {
        "<leader>e",
        group = "🌳 文件树（项目根目录）",
      },
      {
        "<leader>E",
        group = "🌳 文件树（当前目录）",
      },
      {
        "<leader>f",
        group = "🔍 文件/目录搜索",
      },
      {
        "<leader>g",
        group = "🐙 Git",
      },
      -- {
      --   "<leader>H",
      --   group = "📌 Harpoon",
      -- },
      {
        "<leader>N",
        group = "🔔 通知",
      },
      {
        "<leader>p",
        group = "🧩 插件管理 (Lazy)",
      },
      -- {
      --   "<leader>pp",
      --   group = "🖼️ PicGo",
      -- },
      {
        "<leader>q",
        group = "🍪 会话管理",
      },
      {
        "<leader>r",
        group = "👨‍💻 运行代码",
      },
      {
        "<leader>rp",
        group = "🐍 运行Py代码",
      },
      {
        "<leader>rj",
        group = "🟨 运行Js代码",
      },
      {
        "<leader>t",
        group = "🖥️ 终端",
      },
      {
        "<leader>tb",
        group = "🖥️ 底部终端",
      },
      {
        "<leader>tr",
        group = "🖥️ 右侧终端";
      },
      {
        "<leader>tp",
        group = "🐍 Python 终端";
      },
      -- {
      --   "<leader>tj",
      --   group = "🟨 Node.js 终端",
      -- },
      {
        "<leader>s",
        group = "🔍 内容搜索",
      },
      {
        "<leader>u",
        group = "🎛️ UI功能",
      },
      {
        "<leader>uba",
        group = "透明背景",
      },
      {
        "<leader>ubb",
        group = "字符边界线",
      },
      {
        "<leader>w",
        group = "🪟 窗口管理";
      },
      {
        "<leader><leader>",
        group = "🔍 查找文件（项目根目录）";
      },
      -- 被注释掉的组（如有需要可以取消注释）
      -- {
      --   "<leader>C",
      --   group = "🛠️ 代码助手 (Coc)",
      -- },
      -- {
      --   "<leader>ca",
      --   group = "⚡ 代码操作",
      -- },
      -- {
      --   "<leader>cb",
      --   group = "📦 注释框",
      -- },
      -- {
      --   "<leader>cs",
      --   group = "🧩 代码片段",
      -- },
      -- {
      --   "<leader>Ct",
      --   group = "🌐 翻译",
      -- },
    },
    triggers = {
      -- terminal 模式下禁用，否则按 esc 无法退出一些功能
      { "<auto>", mode = "nixsoc" },
    },
    icons = {
      rules = false,
    },
  },
}