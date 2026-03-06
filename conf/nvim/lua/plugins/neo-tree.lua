return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      group_empty_dirs = true,
      commands = {
        git_add = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          vim.fn.system({ "git", "add", path })
          require("neo-tree.sources.manager").refresh("filesystem")
        end,
        git_unstage = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          vim.fn.system({ "git", "restore", "--staged", path })
          require("neo-tree.sources.manager").refresh("filesystem")
        end,
      },
      window = {
        mappings = {
          ["<leader>ga"] = "git_add",
          ["<leader>gu"] = "git_unstage",
        },
      },
    },
  },
}
