-- Description: Visualise the undo tree in a tree-like format
return {
  "jiaoshijie/undotree",
  dependencies = "nvim-lua/plenary.nvim",
  config = true,
  keys = { -- load the plugin only when using it's keybinding:
    -- TODO: This key map isn't working yet...
    { "<leader>uu", "<cmd>lua require('undotree').toggle()<cr>", desc = "Toggle undo menu" },
  },
}
