return {
  "mrjones2014/smart-splits.nvim",
  lazy = false,
  opts = {
    -- Integration is usually auto-detected, but you can be explicit
    multiplexer_integration = "zellij",
    zellij_move_focus_or_tab = true,
    --    at_edge = "multiplexer",
  },
  keys = {
    -- Moving between splits
    {
      "<A-Left>",
      function()
        require("smart-splits").move_cursor_left()
      end,
      desc = "Move to left split",
    },
    {
      "<A-Down>",
      function()
        require("smart-splits").move_cursor_down()
      end,
      desc = "Move to bottom split",
    },
    {
      "<A-Up>",
      function()
        require("smart-splits").move_cursor_up()
      end,
      desc = "Move to top split",
    },
    {
      "<A-Right>",
      function()
        require("smart-splits").move_cursor_right()
      end,
      desc = "Move to right split",
    },
  },
}
