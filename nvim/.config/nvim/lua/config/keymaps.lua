-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- ~/.config/nvim/lua/config/keymaps.lua
-- LazyVim 中文快捷键重新定义

local map = vim.keymap.set
local del = vim.keymap.del
local function map_nv(lhs, rhs, desc)
    map({ "n", "v" }, lhs, rhs, { desc = desc })
end
local toggle = require("snacks").toggle
local picker = require("snacks").picker

-- ============================================================================
-- Lazy 插件管理器相关
-- ============================================================================
-- Lazy 窗口内快捷键（仅在 Lazy 窗口生效）
map("n", "<CR>", "<cmd>Lazy details<cr>", { desc = "显示详情", buffer = true })
map("n", "<C-c>", "<cmd>Lazy abort<cr>", { desc = "中止当前操作", buffer = true })
map("n", "<C-f>", "<cmd>Lazy filter<cr>", { desc = "筛选配置文件", buffer = true })
map("n", "<C-s>", "<cmd>Lazy sort<cr>", { desc = "排序配置文件", buffer = true })

-- ============================================================================
-- 基础导航快捷键
-- ============================================================================
map("n", "0", "^", { desc = "行首（非空白）" })
map("n", "b", "b", { desc = "上一个单词" })
map("n", "B", "B", { desc = "上一个单词（WORD）" })
map("n", "e", "e", { desc = "下一个单词尾" })
map("n", "E", "E", { desc = "下一个单词尾（WORD）" })
map("n", "f", "f", { desc = "移动到下一个字符" })
map("n", "F", "F", { desc = "移动到上一个字符" })
map("n", "gg", "gg", { desc = "第一行" })
map("n", "G", "G", { desc = "最后一行" })
map("n", "h", "h", { desc = "左移" })
map("n", "j", "j", { desc = "下移" })
map("n", "k", "k", { desc = "上移" })
map("n", "l", "l", { desc = "右移" })
map("n", "M", "M", { desc = "窗口中间行" })
map("n", "n", "n", { desc = "下一个搜索结果" })
map("n", "N", "N", { desc = "上一个搜索结果" })
map("n", "w", "w", { desc = "下一个单词" })
map("n", "W", "W", { desc = "下一个单词（WORD）" })

-- ============================================================================
-- 文本操作
-- ============================================================================
map("n", "s", "s", { desc = "闪现跳转" })
map("n", "t", "t", { desc = "移动到下一个字符之前" })
map("n", "T", "T", { desc = "移动到上一个字符之后" })
map("n", "v", "v", { desc = "可视模式" })
map("n", "V", "V", { desc = "可视行模式" })
map("n", "y", "y", { desc = "复制" })
map("n", "Y", "Y", { desc = "复制到行尾" })
map("n", "!", "!", { desc = "运行外部程序" })
map("n", "$", "$", { desc = "行尾" })
map("n", "%", "%", { desc = "匹配括号" })
-- 单行上移：Alt + k
map("n", "<A-k>", ":m -2<CR>==", { desc = "将当前行上移一行" })
-- 单行下移：Alt + j
map("n", "<A-j>", ":m +1<CR>==", { desc = "将当前行下移一行" })
-- 多行上移：Alt + k（可视化模式）
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "将选中的多行上移一行" })
-- 多行下移：Alt + j（可视化模式）
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "将选中的多行下移一行" })

-- ============================================================================
-- 搜索相关
-- ============================================================================
map("n", "&", "&", { desc = "重复上次替换" })
map("n", ",", ",", { desc = "反向重复 f/t/F/T" })
map("n", "/", "/", { desc = "向前搜索" })
map("n", ";", ";", { desc = "重复 f/t/F/T" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "清除搜索高亮" })

-- ============================================================================
-- 缩进操作
-- ============================================================================
map("n", "<", "<<", { desc = "左缩进" })
map("n", ">", ">>", { desc = "右缩进" })
map("v", "<", "<gv", { desc = "左缩进（保持选择）" })
map("v", ">", ">gv", { desc = "右缩进（保持选择）" })

-- ============================================================================
-- 行首尾（非空白字符）
-- ============================================================================
map("n", "^", "^", { desc = "行首（非空白）" })
map("n", "{", "{", { desc = "上一个空行" })
map("n", "}", "}", { desc = "下一个空行" })
map("n", "~", "~", { desc = "切换大小写" })

-- ============================================================================
-- 上下箭头
-- ============================================================================
map("n", "↑", "k", { desc = "上移" })
map("n", "↓", "j", { desc = "下移" })

-- Goto / 跳转
map("n", "gd", vim.lsp.buf.definition, { desc = "跳转到定义" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "跳转到声明" })
map("n", "gI", vim.lsp.buf.implementation, { desc = "跳转到实现" })
map("n", "gK", vim.lsp.buf.signature_help, { desc = "函数签名提示" })
map("n", "gy", vim.lsp.buf.type_definition, { desc = "跳转到类型定义" })
map("n", "gr", vim.lsp.buf.references, { desc = "查找引用" })

map("n", "ge", "e", { desc = "跳转到单词结尾（向前）" })
map("n", "gf", "gf", { desc = "打开光标下的文件" })
map("n", "gg", "gg", { desc = "跳转到第一行" })
map("n", "gi", "gi", { desc = "跳转到上次插入位置" })

map("n", "gn", "gn", { desc = "向前搜索并选中" })
map("n", "gN", "gN", { desc = "向后搜索并选中" })

map("n", "g0", vim.lsp.buf.document_symbol, { desc = "文档符号列表" })

map("n", "gt", "gt", { desc = "切换到下一个标签页" })
map("n", "gT", "gT", { desc = "切换到上一个标签页" })

map("n", "gu", "gu", { desc = "转为小写" })
map("n", "gU", "gU", { desc = "转为大写" })

map("n", "gv", "gv", { desc = "恢复上一次可视选择" })
map("n", "gw", "gw", { desc = "格式化文本" })

map("n", "gx", "gx", { desc = "用系统程序打开链接/文件" })

map("n", "g%", "g%", { desc = "在搜索结果中向后循环" })

map("n", "g;", "g;", { desc = "跳转到较新的修改位置" })
map("n", "g,", "g,", { desc = "跳转到较旧的修改位置" })

map("n", "g[", "g[", { desc = "向左移动（around）" })
map("n", "g]", "g]", { desc = "向右移动（around）" })

map("n", "g~", "g~", { desc = "切换大小写" })

-- ============================================================================
-- 窗口管理（Ctrl + 组合键）
-- ============================================================================
map("n", "<C-/>", "<cmd>terminal<cr>", { desc = "打开终端（根目录）" })
map("n", "<C-b>", "<C-b>", { desc = "向上滚动一屏" })
map("n", "<C-a>", "0", { desc = "跳到行首" })
map("n", "<C-e>", "$", { desc = "跳到行尾" })
map("n", "<C-h>", "<C-w>h", { desc = "跳转到左侧窗口" })
map("n", "<C-j>", "<C-w>j", { desc = "跳转到下方窗口" })
map("n", "<C-k>", "<C-w>k", { desc = "跳转到上方窗口" })
map("n", "<C-l>", "<C-w>l", { desc = "跳转到右侧窗口" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "减小窗口宽度" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "增加窗口宽度" })
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "增加窗口高度" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "减小窗口高度" })

-- 窗口跳转/移动/关闭
map("n", "<C-w>d", "<C-w>d", { desc = "显示光标下的诊断信息" })
map("n", "<C-w>h", "<C-w>h", { desc = "跳转到左侧窗口" })
map("n", "<C-w>H", "<C-w>H", { desc = "移动窗口到最左边" })
map("n", "<C-w>j", "<C-w>j", { desc = "跳转到下侧窗口" })
map("n", "<C-w>J", "<C-w>J", { desc = "移动窗口到最底端" })
map("n", "<C-w>k", "<C-w>k", { desc = "跳转到上侧窗口" })
map("n", "<C-w>K", "<C-w>K", { desc = "移动窗口到最顶端" })
map("n", "<C-w>l", "<C-w>l", { desc = "跳转到右侧窗口" })
map("n", "<C-w>L", "<C-w>L", { desc = "移动窗口到最右边" })
map("n", "<C-w>o", "<C-w>o", { desc = "关闭所有其他窗口" })
map("n", "<C-w>q", "<C-w>q", { desc = "退出一个窗口" })
map("n", "<C-w>T", "<C-w>T", { desc = "拆分到一个新标签页" })
-- 窗口分屏/切换
map("n", "<C-w>s", "<C-w>s", { desc = "水平分割窗口" })
map("n", "<C-w>v", "<C-w>v", { desc = "垂直分割窗口" })
map("n", "<C-w>w", "<C-w>w", { desc = "切换窗口" })
map("n", "<C-w>x", "<C-w>x", { desc = "与下一个窗口交换位置" })
-- 窗口大小调整
map("n", "<C-w>+", "<C-w>+", { desc = "增加窗口高度" })
map("n", "<C-w>-", "<C-w>-", { desc = "减少窗口高度" })
map("n", "<C-w><", "<C-w><", { desc = "减少窗口宽度" })
map("n", "<C-w>=", "<C-w>=", { desc = "平均窗口大小" })
map("n", "<C-w>>", "<C-w>>", { desc = "增加窗口宽度" })
map("n", "<C-w>_", "<C-w>_", { desc = "最大化高度" })
map("n", "<C-w>|", "<C-w>|", { desc = "最大化宽度" })

-- ============================================================================
-- 文件树导航（Ctrl+j/k）
-- ============================================================================
map("n", "⌃j", "j", { desc = "向下移动" })
map("n", "⌃k", "k", { desc = "向上移动" })

-- ============================================================================
-- 扩展功能（+ 前缀）
-- ============================================================================
map("n", "<C-g>", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "跳转到定义" })
map("n", "zR", "<cmd>normal! zR<cr>", { desc = "展开所有折叠" })
map("n", "zM", "<cmd>normal! zM<cr>", { desc = "收起所有折叠" })
map("n", '"', "<cmd>registers<cr>", { desc = "查看寄存器" })
map("n", "'", "<cmd>marks<cr>", { desc = "查看标记" })
map("n", "[", "<cmd>prev<cr>", { desc = "上一项" })
map("n", "\\", "<cmd>vsplit<cr>", { desc = "垂直分割" })
map("n", "]", "<cmd>next<cr>", { desc = "下一项" })
map("n", "`", "<cmd>marks<cr>", { desc = "查看标记" })
map("n", "za", "za", { desc = "切换光标下的折叠" })
map("n", "zA", "zA", { desc = "切换光标下所有折叠" })
map("n", "zb", "zb", { desc = "将当前行置于窗口底部" })
map("n", "zC", "zC", { desc = "关闭光标下的折叠" })
map("n", "zc", "zc", { desc = "关闭光标下所有折叠" })
map("n", "zd", "zd", { desc = "删除光标下的折叠" })
map("n", "zD", "zD", { desc = "删除光标下所有折叠" })
map("n", "ze", "ze", { desc = "将当前行置于窗口右侧" })
map("n", "zE", "zE", { desc = "删除文件中所有折叠" })
map("n", "zf", "zf", { desc = "创建折叠" })
map("n", "zg", "zg", { desc = "将单词添加到拼写列表" })
map("n", "zH", "zH", { desc = "将屏幕分为左半边" })
map("n", "zi", "zi", { desc = "切换折叠开关" })
map("n", "zL", "zL", { desc = "将屏幕分为右半边" })
map("n", "zm", "zm", { desc = "折叠更多" })
map("n", "zM", "zM", { desc = "收起所有折叠" })
map("n", "zo", "zo", { desc = "打开光标下的折叠" })
map("n", "zO", "zO", { desc = "打开光标下所有折叠" })
map("n", "zr", "zr", { desc = "展开少量折叠" })
map("n", "zR", "zR", { desc = "展开所有折叠" })
map("n", "zs", "zs", { desc = "将当前行置于窗口左侧" })
map("n", "zt", "zt", { desc = "将当前行置于窗口顶部" })
map("n", "zv", "zv", { desc = "显示光标行" })
map("n", "zw", "zw", { desc = "将单词标记为错误/拼写错误" })
map("n", "zX", "zX", { desc = "更新折叠" })
map("n", "zz", "zz", { desc = "将当前行置于窗口中央" })
map("n", "z=", "z=", { desc = "拼写建议" })

-- ============================================================================
-- 扩展功能（更多按键）
-- ============================================================================
map("n", "⊣", "<cmd>lua require('which-key').show()<cr>", { desc = "显示 27 个键位映射" })

-- ============================================================================
-- 二级菜单
-- ============================================================================

-- ========== v ==========
-- ========== 可视模式 ==========
map("v", "0", "0", { desc = "行首" })
map("v", "^", "^", { desc = "行首（第一个非空白字符）" })
map("v", "$", "$", { desc = "行尾" })
map("v", "b", "b", { desc = "上一个单词开头" })
map("v", "B", "B", { desc = "上一个大单词开头（忽略标点）" })
map("v", "e", "e", { desc = "下一个单词结尾" })
map("v", "E", "E", { desc = "下一个大单词结尾" })
map("v", "w", "w", { desc = "下一个单词开头" })
map("v", "W", "W", { desc = "下一个大单词开头" })
map("v", "f", "f", { desc = "向前查找字符" })
map("v", "F", "F", { desc = "向后查找字符" })
map("v", "t", "t", { desc = "向前到字符前" })
map("v", "T", "T", { desc = "向后到字符前" })
map("v", "h", "h", { desc = "向左移动" })
map("v", "j", "j", { desc = "向下移动" })
map("v", "k", "k", { desc = "向上移动" })
map("v", "l", "l", { desc = "向右移动" })
map("v", "G", "G", { desc = "文件末尾" })
map("v", "gg", "gg", { desc = "文件开头" })
map("v", "n", "n", { desc = "下一个搜索结果" })
map("v", "N", "N", { desc = "上一个搜索结果" })
map("v", "Y", "Y", { desc = "复制到行尾" })
map("v", "!", "!", { desc = "过滤命令" })
map("v", "~", "~", { desc = "切换大小写" })
map("v", "c", "c", { desc = "修改" })
map("v", "d", "d", { desc = "删除" })
map("v", "r", "r", { desc = "替换单个字符" })
map("v", "R", "R", { desc = "进入替换模式" })
map("v", "s", "s", { desc = "删除字符并进入插入" })
map("v", "S", "S", { desc = "删除行并进入插入" })
map("v", "q", "q", { desc = "录制宏" })
map("v", "Q", "Q", { desc = "播放宏 q" })
map("v", "y", "y", { desc = "复制" })
map("v", "p", "p", { desc = "粘贴到光标后" })
map("v", "P", "P", { desc = "粘贴到光标前" })
map("v", "<", "<", { desc = "左缩进（保持选择）" })
map("v", ">", ">", { desc = "右缩进（保持选择）" })
map("v", "^", "^", { desc = "行首非空白" })
map("v", "0", "0", { desc = "绝对行首" })
map("v", "%", "%", { desc = "匹配括号" })
map("v", "&", "&&", { desc = "重复上一次替换" })
map("v", "/", "/", { desc = "向前搜索" })
map("v", "?", "?", { desc = "向后搜索" })
map("v", "~", "~", { desc = "切换大小写" })
map("v", "@", "@", { desc = "执行宏" })
map("v", "#", "#", { desc = "向前搜索光标词" })
map("v", "*", "*", { desc = "向后搜索光标词" })
map("v", "<", "<gv", { desc = "左缩进并保持选择" })
map("v", ">", ">gv", { desc = "右缩进并保持选择" })
map("v", "^", "^", { desc = "行首非空白" })
map("v", "{", "{", { desc = "上一个空行" })
map("v", "}", "}", { desc = "下一个空行" })
map("v", "~", "~", { desc = "切换大小写" })

-- =============================================================================
-- 3.<leader>开头快捷键（严格按字母顺序排序）
-- =============================================================================

-- ========== a ==========
-- ========== AI 辅助 ==========
map("n", "<leader>at", "<cmd>SupermavenToggle<CR>", { desc = "切换 Supermaven 状态" })
map("n", "<leader>ar", "<cmd>SupermavenRestart<CR>", { desc = "重启 Supermaven" })
map("n", "<leader>ac", "<cmd>SupermavenClear<CR>", { desc = "清除 Supermaven 缓存" })

-- ========== b ==========
-- ========== 缓冲区 (Buffer)(标签页) ==========
-- del("n", "<leader>bb")
del("n", "<leader>bd")
map("n", "<leader>bb", "<cmd>b#<cr>", { desc = "切换到上一个缓冲区" })
map("n", "<leader>bq", "<cmd>bdelete<cr>", { desc = "删除当前缓冲区" })
map("n", "<leader>bD", "<cmd>BufferLinePickClose<cr>", { desc = "选择并删除缓冲区" })
map("n", "<leader>bf", function()
    require("fzf-lua").buffers()
end, { desc = "查找并切换到缓冲区" })
map("n", "<leader>bh", "<cmd>bprevious<cr>", { desc = "切换到上一个缓冲区" })
map("n", "<leader>bl", "<cmd>bnext<cr>", { desc = "切换到下一个缓冲区" })
-- del("n", "<leader>bl")
-- map("n", "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", { desc = "删除左侧所有缓冲区" })
map("n", "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", { desc = "删除其他所有缓冲区" })
map("n", "<leader>bp", "<cmd>BufferLineTogglePin<cr>", { desc = "固定/取消固定当前缓冲区" })
map("n", "<leader>bP", "<cmd>BufferLineClosePinned<cr>", { desc = "删除所有非固定缓冲区" })
del("n", "<leader>br")
-- map("n", "<leader>br", "<cmd>BufferLineCloseRight<cr>", { desc = "删除右侧所有缓冲区" })
map("n", "<leader>b1", "<cmd>buffer 1<cr>", { desc = "切换到缓冲区 1" })
map("n", "<leader>b2", "<cmd>buffer 2<cr>", { desc = "切换到缓冲区 2" })
map("n", "<leader>b3", "<cmd>buffer 3<cr>", { desc = "切换到缓冲区 3" })
map("n", "<leader>b4", "<cmd>buffer 4<cr>", { desc = "切换到缓冲区 4" })
map("n", "<leader>b5", "<cmd>buffer 5<cr>", { desc = "切换到缓冲区 5" })
map("n", "<leader>b6", "<cmd>buffer 6<cr>", { desc = "切换到缓冲区 6" })
map("n", "<leader>b7", "<cmd>buffer 7<cr>", { desc = "切换到缓冲区 7" })
map("n", "<leader>b8", "<cmd>buffer 8<cr>", { desc = "切换到缓冲区 8" })
map("n", "<leader>b9", "<cmd>buffer 9<cr>", { desc = "切换到缓冲区 9" })
map("n", "<leader>.", function()
    Snacks.scratch()
end, { desc = "打开/切换临时草稿区" })
map("n", "<leader>S", function()
    Snacks.scratch.select()
end, { desc = "选择临时草稿区" })

-- ========== c ==========
-- ========== 代码操作 ==========
map("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", { desc = "代码动作（Code Action）" })
map("n", "<leader>cA", "<cmd>Lspsaga code_action<CR>", { desc = "源代码动作（Source Action）" }) -- 部分版本大A是source action
-- map("n", "<leader>cc", vim.lsp.codelens.run, { desc = "运行 CodeLens" })
map("n", "<leader>cc", "<Plug>(comment_toggle_linewise_current)", { desc = "注释/取消注释当前行" })
map("x", "<leader>cc", "<Plug>(comment_toggle_linewise_visual)", { desc = "注释选中行" })
map("n", "<leader>cb", "<Plug>(comment_toggle_blockwise_current)", { desc = "块注释当前行" })
map("x", "<leader>cb", "<Plug>(comment_toggle_blockwise_visual)", { desc = "块注释选中区域" })
map("n", "<leader>cC", vim.lsp.codelens.refresh, { desc = "刷新 CodeLens" })
-- map("n", "<leader>cd", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "显示当前行诊断" })  -- 常见修复所有诊断
-- 显示所有诊断（错误、警告、提示等）
map("n", "<leader>cd", function()
    local all_diagnostics = vim.diagnostic.get()
    if #all_diagnostics == 0 then
        print("没有诊断信息")
        return
    end
    -- 按严重程度分类
    local errors = {}
    local warnings = {}
    local info = {}
    local hints = {}
    for _, diag in ipairs(all_diagnostics) do
        if diag.severity == vim.diagnostic.severity.ERROR then
            table.insert(errors, diag)
        elseif diag.severity == vim.diagnostic.severity.WARN then
            table.insert(warnings, diag)
        elseif diag.severity == vim.diagnostic.severity.INFO then
            table.insert(info, diag)
        elseif diag.severity == vim.diagnostic.severity.HINT then
            table.insert(hints, diag)
        end
    end
    -- 创建摘要信息
    local summary =
        string.format("诊断摘要: %d 错误, %d 警告, %d 信息, %d 提示", #errors, #warnings, #info, #hints)
    -- 显示摘要
    print(summary)
    -- 打开一个浮动窗口显示所有诊断
    vim.diagnostic.setloclist({ open = true })
end, { desc = "显示所有诊断（错误、警告、提示等）" })
-- 或者，使用 fzf-lua 显示所有诊断（如果已安装）
map("n", "<leader>cA", function()
    require("fzf-lua").diagnostics_workspace({
        winopts = {
            height = 0.6,
            width = 0.8,
            preview = {
                layout = "vertical",
                vertical = "down:60%",
            },
        },
    })
end, { desc = "FZF 显示所有诊断" })
-- 只查看错误
map("n", "<leader>ce", function()
    local diagnostics = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    if #diagnostics == 0 then
        print("没有错误")
        return
    end
    vim.diagnostic.open_float(0, { scope = "line", severity = vim.diagnostic.severity.ERROR })
end, { desc = "只查看错误" })
map("n", "<leader>cl", function()
    require("fzf-lua").diagnostics_workspace()
end, { desc = "工作区诊断" })
map("n", "<leader>cM", "<cmd>lua require('lsp').add_missing_imports()<CR>", { desc = "添加缺失的导入" }) -- 根据实际插件调整
map("n", "<leader>co", "<cmd>TSToolsOrganizeImports<CR>", { desc = "整理导入（Organize Imports）" }) -- TS/JS常用
map("n", "<leader>cr", "<cmd>Lspsaga rename<CR>", { desc = "重命名符号" })
map("n", "<leader>cR", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = "重命名文件（或符号）" }) -- 部分版本大R是rename file
map("n", "<leader>cu", "<cmd>TSToolsRemoveUnused<CR>", { desc = "移除未使用的导入" })
map("n", "<leader>cV", "<cmd>TSToolsSelectWorkspaceVersion<CR>", { desc = "选择 TS 工作区版本" }) -- TS特定
map("n", "<leader>cf", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", { desc = "格式化代码" })
map("n", "<leader>cF", "<cmd>Format<CR>", { desc = "格式化注入语言（如注入SQL）" }) -- conform.nvim 等
map("n", "<leader>cm", "<cmd>Mason<CR>", { desc = "打开 Mason（LSP/工具管理器）" })
-- 只查看警告
map("n", "<leader>cw", function()
    local diagnostics = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    if #diagnostics == 0 then
        print("没有警告")
        return
    end
    vim.diagnostic.open_float(0, { scope = "line", severity = vim.diagnostic.severity.WARN })
end, { desc = "只查看警告" })
map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { desc = "跳转到上一个诊断" })
map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", { desc = "跳转到下一个诊断" })

-- ========== e ==========
-- ========== 文件树 ==========
map("n", "<leader>e", function()
    require("snacks").explorer({ cwd = Snacks.git.get_root() })
end, { desc = "文件浏览器（项目根目录）" })
map("n", "<leader>E", function()
    require("snacks").explorer({ cwd = vim.fn.expand("%:p:h") })
end, { desc = "文件浏览器（当前目录）" })

-- ========== f ==========
-- ========== 文件/目录 搜索 ==========
map("n", "<leader>fm", "<cmd>lua vim.lsp.buf.format()<cr>", { desc = "📝 格式化代码", silent = true })
map("n", "<leader>fb", function()
    require("fzf-lua").buffers()
end, { desc = "搜索缓冲区" })
map("n", "<leader>fB", function()
    require("fzf-lua").buffers({ sort_lastused = true, sort_mru = true, ignore_current_buffer = true })
end, { desc = "搜索所有缓冲区" })
del("n", "<leader>fc")
-- 无用配置，不需要查找 Neovim 配置文件
-- map("n", "<leader>fc", function() require("fzf-lua").files({ cwd = "~/.config/nvim" }) end, { desc = "查找 Neovim 配置文件" })
-- 这个就是文件树操作，已经在e中定义了
del("n", "<leader>fe")
del("n", "<leader>fE")
-- map("n", "<leader>fe", function() require("fzf-lua").files({ cwd = Snacks.git.get_root() }) end, { desc = "文件浏览器（根目录）" })
-- map("n", "<leader>fE", function() require("fzf-lua").files({ cwd = vim.fn.expand("%:p:h") }) end, { desc = "文件浏览器（当前目录）" })
map("n", "<leader>ff", function()
    require("fzf-lua").files({ cwd = Snacks.git.get_root() })
end, { desc = "查找文件（项目根目录）" })
map("n", "<leader>fF", function()
    require("fzf-lua").files({ cwd = vim.fn.expand("%:p:h") })
end, { desc = "查找文件（当前目录）" })
map("n", "<leader>fg", function()
    require("fzf-lua").git_files()
end, { desc = "查找 Git 文件" })
map("n", "<leader>fn", "<cmd>enew<CR>", { desc = "新建文件" }) -- 常见的新文件命令
map("n", "<leader>fp", function()
    require("fzf-lua").files({ cwd = require("lazy.core.config").options.root })
end, { desc = "查找插件文件" })
map("n", "<leader>fr", function()
    require("fzf-lua").oldfiles()
end, { desc = "最近打开的文件" })
map("n", "<leader>fR", function()
    require("fzf-lua").oldfiles({ cwd = vim.fn.expand("%:p:h") })
end, { desc = "最近打开的文件（当前目录）" })
-- 禁用打开终端，有很多地方实现了，这里禁用
del("n", "<leader>ft")
-- map("n", "<leader>ft", "<cmd>FloatermNew<CR>", { desc = "打开终端（根目录）" })
map("n", "<leader>fT", function()
    local cwd = vim.fn.expand("%:p:h")
    vim.cmd("FloatermNew --cwd=" .. cwd)
end, { desc = "打开终端（当前目录）" })
map("n", "<leader>f/", function()
    require("fzf-lua").files({ cwd = vim.fn.expand("~") })
end, { desc = "查找文件（家目录）" })

-- ========== g ==========
-- ========== git ==========
map("n", "<leader>gb", function()
    Snacks.git.blame_line({ full = true })
end, { desc = "Git 查看本行提交记录" })
map("n", "<leader>gB", function()
    require("fzf-lua").git_bcommits()
end, { desc = "当前文件所有提交" })
map("n", "<leader>gd", function()
    require("gitsigns").diffthis()
end, { desc = "Git 对比当前文件" })
map("n", "<leader>gD", function()
    require("gitsigns").diffthis("~")
end, { desc = "Git 对比 origin/main" })
map("n", "<leader>gf", function()
    require("fzf-lua").git_commits()
end, { desc = "当前文件提交历史" })
map("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "打开 LazyGit" })
map("n", "<leader>gG", "<cmd>LazyGitFilterCurrentFile<CR>", { desc = "打开 LazyGit（当前文件）" })
map("n", "<leader>gs", function()
    require("fzf-lua").git_status()
end, { desc = "Git 状态" })
map("n", "<leader>gl", function()
    require("fzf-lua").git_commits()
end, { desc = "项目提交日志" })
map("n", "<leader>gh", function()
    require("gitsigns").preview_hunk()
end, { desc = "预览 hunk" })
map("n", "<leader>gn", function()
    require("gitsigns").next_hunk()
end, { desc = "下一个 hunk" })
map("n", "<leader>gp", function()
    require("gitsigns").prev_hunk()
end, { desc = "上一个 hunk" })
map("n", "<leader>gS", function()
    require("gitsigns").stage_hunk()
end, { desc = "暂存当前 hunk" })
map("v", "<leader>gS", function()
    require("gitsigns").stage_hunk()
end, { desc = "暂存当前 hunk" })
map("n", "<leader>gR", function()
    require("gitsigns").reset_hunk()
end, { desc = "撤销当前 hunk" })
map("v", "<leader>gR", function()
    require("gitsigns").reset_hunk()
end, { desc = "撤销当前 hunk" })
map("n", "<leader>gu", function()
    require("gitsigns").undo_stage_hunk()
end, { desc = "撤销暂存 hunk" })
-- map("n", "<leader>gi", function() require("fzf-lua").gh_issues() end, { desc = "GitHub Issues" })
-- map("n", "<leader>gP", function() require("fzf-lua").gh_pr() end, { desc = "GitHub Pull Requests" })

-- ========== k ==========
-- ========== 暂时不知道什么作用,没反应 ==========
del("n", "<leader>K")

-- ========== l ==========
-- ========== Lazy ==========
map("n", "<leader>l", function()
    require("lazy").show()
end, { desc = "打开 Lazy管理" })
-- 禁用Lazy版本说明
del("n", "<leader>L")

-- ========== n ==========
-- ========== 通知历史 ==========
del("n", "<leader>sn")
map("n", "<leader>n", function()
    Snacks.notifier.show_history()
end, { desc = "🔔 通知历史", silent = true })

-- ========== p ==========
-- ========== Lazy插件 ==========
map("n", "<leader>pl", "<cmd>Lazy<cr>", { desc = "打开 Lazy 插件管理器" })
map("n", "<leader>pC", "<cmd>Lazy check<cr>", { desc = "检查更新并显示日志 (git fetch)" })
map("n", "<leader>pc", "<cmd>Lazy check<cr>", { desc = "检查更新并显示日志 (git fetch)" })
map("n", "<leader>pd", "<cmd>Lazy debug<cr>", { desc = "显示调试信息" })
map("n", "<leader>pH", "<cmd>Lazy home<cr>", { desc = "返回插件列表" })
map("n", "<leader>pi", "<cmd>Lazy install<cr>", { desc = "安装插件" })
map("n", "<leader>pI", "<cmd>Lazy install<cr>", { desc = "安装缺失的插件" })
map("n", "<leader>pK", "<cmd>Lazy hover<cr>", { desc = "悬停显示详情" })
map("n", "<leader>pL", "<cmd>Lazy log<cr>", { desc = "显示最近更新" })
map("n", "<leader>pP", "<cmd>Lazy profile<cr>", { desc = "显示详细性能分析" })
map("n", "<leader>pq", "<cmd>Lazy close<cr>", { desc = "关闭 Lazy 窗口" })
map("n", "<leader>pr", "<cmd>Lazy restore<cr>", { desc = "恢复插件状态" })
map("n", "<leader>pR", "<cmd>Lazy restore<cr>", { desc = "恢复所有插件到锁定文件状态" })
map("n", "<leader>pS", "<cmd>Lazy sync<cr>", { desc = "运行 install、clean 和 update" })
map("n", "<leader>pu", "<cmd>Lazy update<cr>", { desc = "更新插件并更新锁定文件" })
map("n", "<leader>pU", "<cmd>Lazy update<cr>", { desc = "更新插件并更新锁定文件" })
map("n", "<leader>px", "<cmd>Lazy clean<cr>", { desc = "删除插件（警告：会删除文件）" })
map("n", "<leader>pX", "<cmd>Lazy clear<cr>", { desc = "清理不再需要的插件" })
map("n", "<leader>p?", "<cmd>Lazy help<cr>", { desc = "切换帮助页面" })

-- ========== q ==========
-- ========== 会话管理 ==========
map("n", "<leader>qd", function()
    require("persistence").stop()
end, { desc = "本次退出不保存会话" })
map("n", "<leader>ql", function()
    require("persistence").load.last()
end, { desc = "恢复上次自动保存的会话" })
map("n", "<leader>qq", function()
    vim.cmd.qa()
end, { desc = "全部退出 Neovim（不保存）" })
map("n", "<leader>qQ", function()
    vim.cmd.qa("!")
end, { desc = "强制全部退出（丢弃所有更改）" })
map("n", "<leader>qs", function()
    require("persistence").load()
end, { desc = "保存当前会话" })
map("n", "<leader>qS", function()
    require("persistence").select()
end, { desc = "选择并恢复历史会话" })
map("n", "<leader>qf", function()
    vim.cmd("FloatermKill!")
    vim.cmd("qa")
end, { desc = "退出前关闭所有浮动终端", silent = true })

-- ========== r ==========
-- ========== JavaScript 运行 ==========
-- 浮动终端运行（保持打开）
map(
    "n",
    "<leader>rjf",
    "<cmd>FloatermNew --autoclose=0 node '%'<cr>",
    { desc = "🟨 浮动终端运行JavaScript", silent = true }
)
-- 下半区运行（保持打开）
map(
    "n",
    "<leader>rjb",
    "<cmd>FloatermNew --wintype=split --height=20 --autoclose=0 node '%'<cr>",
    { desc = "🟨 下半区运行JavaScript", silent = true }
)
-- 右半区运行（保持打开）
-- map("n", "<leader>rjb", "<cmd>FloatermNew --wintype=split --height=20 --autoclose=0 node '%'<cr>", { desc = "🟨 下半区运行JavaScript", silent = true })
-- ========== Python 虚拟环境运行 ==========
-- 浮动终端运行（保持打开）
map(
    "n",
    "<leader>rpf",
    "<cmd>FloatermNew --autoclose=0 /home/pullautumn/Code/Python/.venv/bin/python '%'<cr>",
    { desc = "🐍 浮动终端运行Python", silent = true }
)
-- 下半区运行（保持打开）
map(
    "n",
    "<leader>rpb",
    "<cmd>FloatermNew --wintype=split --height=20 --autoclose=0 /home/pullautumn/Code/Python/.venv/bin/python '%'<cr>",
    { desc = "🐍 下半区运行Python", silent = true }
)
-- 右半区运行（保持打开）
-- map("n", "<leader>rpb", "<cmd>FloatermNew --wintype=split --height=20 --autoclose=0 /home/pullautumn/Code/Python/.venv/bin/python '%'<cr>", { desc = "🐍 下半区运行Python", silent = true })

-- ========== s ==========
-- ========== 内容/符号 搜索 ==========
map("n", "<leader><leader>", function()
    require("fzf-lua").files({ cwd = require("lazyvim.util").root.get() })
end, { desc = "🔍 查找文件（项目根目录）" })
-- LSP 符号（标准 builtin）
map("n", "<leader>ss", function()
    require("fzf-lua").lsp_document_symbols()
end, { desc = "当前文件内的方法" })
map("n", "<leader>sS", function()
    require("fzf-lua").lsp_live_workspace_symbols()
end, { desc = "当前工作区内的方法" })
-- 自动命令 & 缓冲区搜索
map("n", "<leader>sa", function()
    require("fzf-lua").autocmds()
end, { desc = "自动命令" })
map("n", "<leader>sb", function()
    require("fzf-lua").lines()
end, { desc = "当前缓冲区行搜索" })
map("n", "<leader>sB", function()
    require("fzf-lua").blines({
        buf = vim.tbl_map(function(b)
            return vim.api.nvim_buf_get_name(b)
        end, vim.api.nvim_list_bufs()),
    })
end, { desc = "Grep 所有打开缓冲区" })
-- 命令历史
map("n", "<leader>sc", function()
    require("fzf-lua").command_history()
end, { desc = "命令历史" })
map("n", "<leader>sC", function()
    require("fzf-lua").commands()
end, { desc = "所有命令" })
-- 诊断
map("n", "<leader>sd", function()
    require("fzf-lua").diagnostics_workspace()
end, { desc = "工作区诊断" })
map("n", "<leader>sD", function()
    require("fzf-lua").diagnostics_document()
end, { desc = "当前缓冲区诊断" })
-- Grep 搜索
map("n", "<leader>sg", function()
    require("fzf-lua").live_grep({ cwd = Snacks.git.get_root() })
end, { desc = "Grep （项目根目录）" })
map("n", "<leader>sG", function()
    require("fzf-lua").live_grep({ cwd = vim.uv.cwd() })
end, { desc = "Grep （当前目录）" })
-- 帮助 & 高亮
map("n", "<leader>sh", function()
    require("fzf-lua").help_tags()
end, { desc = "帮助页面" })
map("n", "<leader>sH", function()
    require("fzf-lua").highlights()
end, { desc = "高亮组" })
-- 图标 & 跳转
del("n", "<leader>si")
-- map("n", "<leader>si", function() require("fzf-lua").icons() end, { desc = "图标查找" })  -- 需要 devicons 插件
map("n", "<leader>sj", function()
    require("fzf-lua").jumps()
end, { desc = "跳转列表" })
map("n", "<leader>sk", function()
    require("fzf-lua").keymaps()
end, { desc = "快捷键列表" })
-- 位置列表 & 标记
map("n", "<leader>sl", function()
    require("fzf-lua").loclist()
end, { desc = "位置列表" })
map("n", "<leader>sm", function()
    require("fzf-lua").marks()
end, { desc = "标记列表" })
-- Man 手册页
map("n", "<leader>sM", function()
    require("fzf-lua").man_pages()
end, { desc = "Man 手册页" })
-- 插件 & Quickfix
map("n", "<leader>sp", function()
    require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
end, { desc = "搜索插件 spec" })
map("n", "<leader>sq", function()
    require("fzf-lua").quickfix()
end, { desc = "Quickfix 列表" })
-- 恢复 & 寄存器
map("n", "<leader>sR", function()
    require("fzf-lua").resume()
end, { desc = "恢复上一次搜索" })
map("n", '<leader>s"', function()
    require("fzf-lua").registers()
end, { desc = "寄存器内容" }) -- 官方是 s"
-- Undo & 搜索历史
map("n", "<leader>s/", function()
    require("fzf-lua").search_history()
end, { desc = "搜索历史" })
-- map("n", "<leader>su", function() require("fzf-lua").undo() end, { desc = "Undo 历史" })  -- 需要 plenary.nvim 插件
-- 视觉搜索 & Todo
map_nv("<leader>sw", function()
    require("fzf-lua").grep_cword({ cwd = Snacks.git.get_root() })
end, "搜索光标词（项目根目录）")
map_nv("<leader>sW", function()
    require("fzf-lua").grep_cword({ cwd = vim.uv.cwd() })
end, "搜索光标词（当前目录）")
map_nv("<leader>st", function()
    require("fzf-lua").grep({ search = "TODO|FIXME|HACK|NOTE", search_fields = "content" })
end, "Todo 注释列表")

-- ========== t ==========
-- ========== 终端管理 ==========
map(
    "n",
    "<leader>tb",
    "<cmd>FloatermNew --wintype=split --height=0.4<cr>",
    { desc = "🖥️ 底部终端", silent = true }
)
-- map("n", "<leader>tj", "<cmd>FloatermNew --wintype=float --width=0.9 --height=0.9  node <cr>", { desc = "🟨 Node.js 终端", silent = true })
-- map("n", "<leader>tol", "<cmd>FloatermNew --wintype=float --width=0.9 --height=0.9 lua<cr>", { desc = "🌙 Lua 终端", silent = true })
map(
    "n",
    "<leader>tp",
    "<cmd>FloatermNew --wintype=float --width=0.9 --height=0.9 /home/pullautumn/Code/Python/.venv/bin/python <cr>",
    { desc = "🐍 Python 终端", silent = true }
)
map(
    "n",
    "<leader>tr",
    "<cmd>FloatermNew --wintype=vsplit --width=0.4<cr>",
    { desc = "🖥️ 右侧终端", silent = true }
)
map("n", "<leader>tf", "<cmd>FloatermNew --autoclose=0 zsh<cr>", { desc = "🖥️ 浮动终端", silent = true })

-- ========== u ==========
-- ========== ui ==========
toggle({
    name = "动画效果",
    get = function()
        return vim.g.animations_enabled ~= false
    end,
    set = function(v)
        vim.g.animations_enabled = v
    end,
}):map("<leader>ua")
toggle({
    name = "明暗主题",
    get = function()
        return vim.o.background == "dark"
    end,
    set = function(v)
        vim.o.background = v and "dark" or "light"
    end,
}):map("<leader>ub")
toggle({
    name = "透明背景",
    get = function()
        return vim.g.minibackground_transparent == true
    end,
    set = function(v)
        vim.g.minibackground_transparent = v
        vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
    end,
}):map("<leader>uB")
toggle({
    name = "代码隐藏",
    get = function()
        return vim.o.conceallevel > 0
    end,
    set = function(v)
        vim.o.conceallevel = v and 2 or 0
    end,
}):map("<leader>uc")
toggle({
    name = "诊断显示",
    get = function()
        return not vim.diagnostic.is_disabled()
    end,
    set = function(v)
        if v then
            vim.diagnostic.enable()
        else
            vim.diagnostic.disable()
        end
    end,
}):map("<leader>ud")
toggle({
    name = "全局自动格式化",
    get = function()
        return vim.g.autoformat_enabled ~= false
    end,
    set = function(v)
        vim.g.autoformat_enabled = v
    end,
}):map("<leader>uf")
toggle({
    name = "当前文件自动格式化",
    get = function()
        return vim.b.autoformat ~= false
    end,
    set = function(v)
        vim.b.autoformat = v
    end,
}):map("<leader>uF")
toggle({
    name = "Git 行号标记",
    get = function()
        return vim.b.gitsigns_signs_enabled ~= false
    end,
    set = function(v)
        require("gitsigns").toggle_signs(v)
    end,
}):map("<leader>ug")
toggle({
    name = "Git 行高亮",
    get = function()
        return vim.b.gitsigns_linehl_enabled
    end,
    set = function(v)
        require("gitsigns").toggle_linehl(v)
    end,
}):map("<leader>uG")
toggle({
    name = "搜索高亮",
    get = function()
        return vim.o.hlsearch
    end,
    set = function(v)
        vim.o.hlsearch = v
    end,
}):map("<leader>uh")
toggle({
    name = "光标行高亮",
    get = function()
        return vim.o.cursorline
    end,
    set = function(v)
        vim.o.cursorline = v
    end,
}):map("<leader>ui")
toggle({
    name = "行号显示",
    get = function()
        return vim.o.number
    end,
    set = function(v)
        vim.o.number = v
        vim.o.relativenumber = v
    end,
}):map("<leader>ul")
toggle({
    name = "相对行号",
    get = function()
        return vim.o.relativenumber
    end,
    set = function(v)
        vim.o.relativenumber = v
    end,
}):map("<leader>uL")
toggle({
    name = "自动补全括号",
    get = function()
        return not vim.g.minipairs_disable
    end,
    set = function(v)
        require("mini.pairs").setup({ disable = not v })
    end,
}):map("<leader>up")
toggle({
    name = "拼写检查",
    get = function()
        return vim.o.spell
    end,
    set = function(v)
        vim.o.spell = v
    end,
}):map("<leader>us")
toggle({
    name = "平滑滚动",
    get = function()
        return vim.o.smoothscroll
    end,
    set = function(v)
        vim.o.smoothscroll = v
    end,
}):map("<leader>uS")
toggle({
    name = "函数上下文高亮",
    get = function()
        return require("treesitter-context").enabled()
    end,
    set = function(v)
        require("treesitter-context").setup({ enable = v })
    end,
}):map("<leader>ut")
toggle({
    name = "自动折行",
    get = function()
        return vim.wo.wrap
    end,
    set = function(v)
        vim.wo.wrap = v
    end,
}):map("<leader>uw")
toggle({
    name = "极简禅模式",
    get = function()
        return false
    end,
    set = function(v)
        if v then
            vim.cmd("ZenMode")
        end
    end,
}):map("<leader>uz")
toggle({
    name = "字符边界线 (colorcolumn)",
    get = function()
        return vim.opt.colorcolumn:get() ~= ""
    end,
    set = function(v)
        vim.opt.colorcolumn = v and "80,120" or ""
    end,
}):map("<leader>uC")

-- ========== w ==========
-- ========== 窗口管理 ==========
-- 删除默认配置，不然快速按下 <leader>wr 不会触发（新版本已修复）
-- del("n", "<leader>w")
map("n", "<leader>wb", "<C-W>s", { desc = "⬇️ 下方分屏", remap = true })
del("n", "<leader>wd")
map("n", "<leader>wq", "<C-W>q", { desc = "❌ 关闭当前窗口", remap = true })
map("n", "<leader>we", "<C-W>=", { desc = "⚖️ 等分窗口大小", remap = true })
map("n", "<leader>wh", "5<C-W><", { desc = "⬅️ 减少窗口宽度", remap = true })
map("n", "<leader>wj", "5<C-W>-", { desc = "📉 减少窗口高度", remap = true })
map("n", "<leader>wk", "5<C-W>+", { desc = "📈 增加窗口高度", remap = true })
map("n", "<leader>wl", "5<C-W>>", { desc = "➡️ 增加窗口宽度", remap = true })
-- map("n", "<leader>wm", { desc = " 缩放模式", remap = true })
map("n", "<leader>wo", "<C-W>o", { desc = "🗑️ 仅保留当前窗口", remap = true })
map("n", "<leader>wr", "<C-W>v", { desc = "➡️ 右侧分屏", remap = true })

