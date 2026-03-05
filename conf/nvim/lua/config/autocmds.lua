-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Only show statuscolumn in normal file buffers
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "FileType", "TermOpen" }, {
  group = vim.api.nvim_create_augroup("statuscolumn_toggle", { clear = true }),
  callback = function()
    if vim.bo.buftype == "" then
      vim.opt_local.statuscolumn = "%s %{v:lnum} %{v:relnum} "
    else
      vim.opt_local.statuscolumn = ""
    end
  end,
})
