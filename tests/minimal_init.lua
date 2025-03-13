local M = {}

function M.root(root)
    local f = debug.getinfo(1, "S").source:sub(2)
    return vim.fn.fnamemodify(f, ":p:h:h") .. "/" .. (root or "")
end

function M.setup_treesitter()
    print("[TREESITTER] Setting up nvim-treesitter")
    -- local parser_cfgs = require("nvim-treesitter.parsers").get_parser_configs()
    -- for parser_name, parser_cfg in pairs({
    --     rescript = {
    --         install_info = {
    --             url = "https://github.com/rescript-lang/tree-sitter-rescript",
    --             branch = "main",
    --             files = { "src/parser.c" },
    --             generate_requires_npm = false,
    --             requires_generate_from_grammar = true,
    --             use_makefile = true,
    --         },
    --     },
    -- }) do
    --     parser_cfgs[parser_name] = parser_cfg
    -- end
    require("nvim-treesitter.configs").setup({
        -- sync_install = true,
        -- ensure_installed = {
        --     "html",
        --     "javascript",
        --     "typescript",
        --     "svelte",
        --     "vue",
        --     "tsx",
        --     "php",
        --     "glimmer",
        --     "rescript",
        --     "templ",
        --     "embedded_template",
        -- },
    })
    print("[TREESITTER] Done setting up nvim-treesitter")
end

function M.setup()
    -- vim.cmd([[set runtimepath=$VIMRUNTIME]])
    vim.opt.runtimepath:append(M.root())
    -- vim.print(vim.opt.runtimepath)
    -- vim.opt.expandtab = true
    -- vim.env.XDG_CONFIG_HOME = M.root(".tests/config")
    -- vim.env.XDG_DATA_HOME = M.root(".tests/data")
    -- vim.env.XDG_STATE_HOME = M.root(".tests/state")
    -- vim.env.XDG_CACHE_HOME = M.root(".tests/cache")
    M.setup_treesitter()
    require("nvim-ts-autotag").setup({
        opts = {
            enable_rename = true,
            enable_close = true,
            enable_close_on_slash = true,
        },
    })
end

M.setup()
