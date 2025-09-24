vim.opt.termguicolors = true
require("bufferline").setup{
    options = { 
        diagnostics = "nvim_lsp",
        offsets = {
            {
                filetype = "NvimTree",
                text = "File Explorer",
                text_align = "left",
                separator = true
            }
        },
        color_icons = false, -- w 
    }
}