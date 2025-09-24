-- Block cursor in all modes
vim.opt.guicursor = ""

-- Line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Disable line wrapping
vim.opt.wrap = false

-- File backup settings
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Search behavior
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Enable 24-bit RGB colors
vim.opt.termguicolors = true

-- UI settings
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- Faster updates
vim.opt.updatetime = 50

-- Visual guide at column 80
vim.opt.colorcolumn = "80"

-- Key sequence detection
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Disable mouse
vim.o.mouse = a
