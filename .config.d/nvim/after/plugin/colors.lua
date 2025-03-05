-- Disable background for transparency
require('tokyonight').setup({
    disable_background = true
})

-- Apply colorscheme with transparent background
function ColorMyPencils(color) 
	color = color or "tokyonight-night"
	vim.cmd.colorscheme(color)

	-- Make background transparent
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

-- Initialize colorscheme
ColorMyPencils()
