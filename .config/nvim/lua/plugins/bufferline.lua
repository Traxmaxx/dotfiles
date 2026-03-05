return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      -- stylua: ignore
      close_command = function(n) Snacks.bufdelete(n) end,
      -- stylua: ignore
      right_mouse_command = function(n) Snacks.bufdelete(n) end,
      diagnostics = "nvim_lsp",
      always_show_bufferline = false,
      diagnostics_indicator = function(_, _, diag)
        local icons = LazyVim.config.icons.diagnostics
        local ret = (diag.error and icons.Error .. diag.error .. " " or "")
          .. (diag.warning and icons.Warn .. diag.warning or "")
        return vim.trim(ret)
      end,
      offsets = {
        {
          filetype = "neo-tree",
          text = "Neo-tree",
          highlight = "Directory",
          text_align = "left",
        },
        {
          filetype = "snacks_layout_box",
        },
      },
      ---@param opts bufferline.IconFetcherOpts
      get_element_icon = function(opts)
        return LazyVim.config.icons.ft[opts.filetype]
      end,
      left_mouse_command = function(bufid)
        local current_win = vim.api.nvim_get_current_win()
        local buf = vim.api.nvim_win_get_buf(current_win)
        local buftype = vim.bo[buf].buftype
        local filetype = vim.bo[buf].filetype

        local is_sidebar = buftype ~= ""
          or filetype:match("snacks")
          or filetype:match("Telescope")
          or filetype:match("NvimTree")
          or filetype:match("neo%-tree")
          or filetype == "openclaude_ask"

        if is_sidebar then
          local target_pos = vim.api.nvim_win_get_position(current_win)
          local target_width = vim.api.nvim_win_get_width(current_win)
          local target_height = vim.api.nvim_win_get_height(current_win)
          local target_left = target_pos[2]
          local target_top = target_pos[1]
          local target_bottom = target_top + target_height

          local closest_win = nil
          local closest_distance = math.huge

          for _, win in ipairs(vim.api.nvim_list_wins()) do
            if win ~= current_win then
              local win_pos = vim.api.nvim_win_get_position(win)
              local win_width = vim.api.nvim_win_get_width(win)
              local win_height = vim.api.nvim_win_get_height(win)

              local win_left = win_pos[2]
              local win_right = win_left + win_width
              local win_top = win_pos[1]
              local win_bottom = win_top + win_height

              local vertical_overlap = not (win_bottom <= target_top or win_top >= target_bottom)
              local to_the_left = win_right <= target_left

              if vertical_overlap and to_the_left then
                local distance = target_left - win_right
                if distance < closest_distance then
                  closest_distance = distance
                  closest_win = win
                end
              end
            end
          end

          if closest_win then
            vim.api.nvim_set_current_win(closest_win)
          else
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local win_buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[win_buf].buftype == "" then
                vim.api.nvim_set_current_win(win)
                break
              end
            end
          end
        end

        vim.cmd("buffer " .. bufid)
      end,
    },
  },
}
