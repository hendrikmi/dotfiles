-- import nvim-treesitter plugin safely
local status, treesitter = pcall(require, "nvim-treesitter.configs")
if not status then
    return
end

-- configure treesitter
treesitter.setup({
    -- enable syntax highlighting
    highlight = {
        enable = true,
    },
    -- enable indentation
    indent = { enable = true, disable = { "python", "css", "yaml" } },
    -- enable autotagging (w/ nvim-ts-autotag plugin)
    autotag = { enable = true },
    autopairs = { enable = true },
    -- ensure these language parsers are installed
    ensure_installed = {
        "python",
        "regex",
        "terraform",
        "sql",
        "dockerfile",
        "toml",
        "json",
        "javascript",
        "typescript",
        "tsx",
        "yaml",
        "html",
        "css",
        "markdown",
        "markdown_inline",
        "svelte",
        "graphql",
        "bash",
        "lua",
        "vim",
        "dockerfile",
        "gitignore",
    },
    -- auto install above language parsers
    auto_install = true,
})
