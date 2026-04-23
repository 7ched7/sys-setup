vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
	
    -- theme
    {
        "bluz71/vim-moonfly-colors",
	    name = "moonfly",
	    lazy = false,
	    priority = 1000,
	    config = function()
	        vim.cmd("colorscheme moonfly")
        end
    },

    -- telescope
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function() 
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
            vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
        end
    },

    -- nvim-tree
    {
        "nvim-tree/nvim-tree.lua",
        config = function()
            require'nvim-tree'.setup {
                git = {
                    enable = true,
                },
                renderer = {
                    icons = {
                        show = {
                            git = true,
                            folder = false,
                            folder_arrow = false,
                            file = false,
                        },
                    },
                },
            }
            vim.api.nvim_set_keymap('n', '<C-t>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<C-n>', ':NvimTreeFocus<CR>', { noremap = true, silent = true })
        end,
    },

    -- nvim-treesitter
    {
    	"nvim-treesitter/nvim-treesitter",
    	build = ":TSUpdate",
    	config = function()
      	    require("nvim-treesitter.configs").setup({
                ensure_installed = { "python", "bash", "json", },
                highlight = {
                    enable = true,
         	    },
                indent = {
                    enable = true
                },
                autotag = { enable = true },
                autopairs = { enable = true },
            })
    	end
    },

    -- autopair
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup{}
        end
    },

    -- lsp
    {
        "neovim/nvim-lspconfig",
        config = function()
            vim.lsp.enable('pyright')
            vim.lsp.enable('gopls')
            vim.lsp.enable('bashls')
            vim.lsp.enable('clangd')
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {})
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
	        vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, {})        
	    end
    },

    -- nvim-cmp 
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",  
            "hrsh7th/cmp-buffer",    
            "hrsh7th/cmp-path",
	        "hrsh7th/vim-vsnip",
            "hrsh7th/cmp-vsnip",
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body)
                    end,
                },
                mapping = {
                    ['<Tab>'] = cmp.mapping.select_next_item(),
                    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
                    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-u>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<Esc>'] = cmp.mapping.close(),
                },
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'buffer' },
                    { name = 'path' },
		            { name = 'vsnip' },
                }
            })
        end
    },

}

local opts = {}

require("lazy").setup(plugins, opts)
