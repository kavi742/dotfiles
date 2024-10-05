-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local wk = require("which-key")
local bind = vim.keymap.set

wk.register({
  a = {
    name = "Arduino",
    c = { "<cmd>! arduino-cli compile -b arduino:avr:uno -p /dev/ttyACM0 % <cr>", "Compile" },
    u = { "<cmd>! arduino-cli upload -b arduino:avr:uno -p /dev/ttyACM0 % <cr>", "Upload" },
    r = {
      "<cmd>! arduino-cli compile -b arduino:avr:uno -p /dev/ttyACM0 % && arduino-cli upload -b arduino:avr:uno -p /dev/ttyACM0 % <cr>",
      "Compile and Upload",
    },
    m = { "<cmd>split | terminal arduino-cli monitor -p /dev/ttyACM0 % <cr>", "Monitor" },
  },
}, { prefix = "<leader>" })

bind("n", "<C-S>", "<cmd>:luafile %<cr>")
