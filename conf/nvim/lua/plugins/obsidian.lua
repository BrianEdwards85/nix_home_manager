return {
  {
    "obsidian-nvim/obsidian.nvim",
    -- ft = "markdown",
    event = {
      "BufReadPre " .. vim.fn.expand("~") .. "/obsidian/*.md",
      "BufNewFile " .. vim.fn.expand("~") .. "/obsidian/*.md",
    },

    opts = {
      legacy_commands = false,
      workspaces = {
        {
          name = "bullet",
          path = "~/obsidian/Bullet",
        },
      },
    },
  },
}
