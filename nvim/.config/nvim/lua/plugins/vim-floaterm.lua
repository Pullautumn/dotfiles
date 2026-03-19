-- ~/.config/nvim/lua/plugins/vim-floaterm.lua
-- 终端插件配置

return {
  "voldikss/vim-floaterm",
  event = "VeryLazy",
  config = function()
    vim.g.floaterm_borderchars = "─│─│╭╮╯╰"
    -- 设置从 floaterm 打开文件的状态
    vim.g.floaterm_opener = "edit"

    local hl = vim.api.nvim_set_hl
    -- 设置 floaterm 失去焦点后的前景色
    hl(0, "FloatermNC", { fg = "gray" })
  end,
}