require("lint").linters_by_ft = {
	lua = { "selene" },
	python = { "ruff" },
	rust = { "rustlint" },
	ruby = { "ruby" },
	javascript = { "eslint_d" },
	javascriptreact = { "eslint_d" },
	typescript = { "eslint_d" },
	typescriptreact = { "eslint_d" },
	vue = { "eslint_d" },
	svelte = { "eslint_d" },
	astro = { "eslint_d" },
	htmlangular = { "eslint_d" },
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		-- try_lint without arguments runs the linters defined in `linters_by_ft`
		-- for the current filetype
		require("lint").try_lint()
	end,
})
