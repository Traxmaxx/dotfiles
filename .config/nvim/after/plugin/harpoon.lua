local wk = require("which-key")
local harpoon = require("harpoon")
harpoon:setup({})

-- basic telescope configuration
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require("telescope.pickers")
        .new({}, {
            prompt_title = "Harpoon",
            finder = require("telescope.finders").new_table({
                results = file_paths,
            }),
            previewer = conf.file_previewer({}),
            sorter = conf.generic_sorter({}),
        })
        :find()
end
-- Which-key integration for harpoon
wk.add({
    -- Create harpoon group
    { "<leader>n", group = "Harpoon", mode = "n" },

    -- Mark file
    {
        "<C-e>",
        function()
            toggle_telescope(harpoon:list())
        end,
        desc = "Open harpoon window",
        mode = "n",
    },

    -- Quick menu toggle
    {
        "<C-e>",
        function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Toggle Quick Menu",
        mode = "n",
    },

    -- Navigation
    {
        "<C-h>",
        function()
            harpoon:list():select(1)
        end,
        desc = "Nav File 1",
        mode = "n",
    },
    {
        "<C-t>",
        function()
            harpoon:list():select(2)
        end,
        desc = "Nav File 2",
        mode = "n",
    },
    {
        "<C-n>",
        function()
            harpoon:list():select(3)
        end,
        desc = "Nav File 3",
        mode = "n",
    },
    {
        "<C-s>",
        function()
            harpoon:list():select(4)
        end,
        desc = "Nav File 4",
        mode = "n",
    },
    {
        "<C-S-P>",
        function()
            harpoon:list():prev()
        end,
        desc = "Nav File 4",
        mode = "n",
    },
    {
        "<C-S-N>",
        function()
            harpoon:list():next()
        end,
        desc = "Nav File 4",
        mode = "n",
    },
})
