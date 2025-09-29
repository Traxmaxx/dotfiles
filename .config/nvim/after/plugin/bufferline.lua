require("bufferline").setup({
    options = {
        diagnostics = "nvim_lsp",
        offsets = {
            {
                filetype = "NvimTree",
                text = "File Explorer",
                text_align = "left",
                separator = true,
            },
        },
        color_icons = false, -- w
        close_command = function ()
            local prev = vim.fn.bufnr("#")
            vim.cmd("bd")
            if prev > 0 and vim.fn.buflisted(prev) == 1 then
                vim.cmd("b " .. prev)
            end
        end,
    },
})
