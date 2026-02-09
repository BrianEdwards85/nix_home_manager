-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("t", "<C-Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", "<leader><Left>", "<C-w>h", { desc = "Go to left window", remap = true })
vim.keymap.set("n", "<leader><Right>", "<C-w>l", { desc = "Go to right window", remap = true })
vim.keymap.set("n", "<leader><Up>", "<C-w>k", { desc = "Go to upper window", remap = true })
vim.keymap.set("n", "<leader><Down>", "<C-w>j", { desc = "Go to lower window", remap = true })
