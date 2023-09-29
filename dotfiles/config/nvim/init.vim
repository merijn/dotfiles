set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
call plug#begin()
Plug 'neovim/nvim-lspconfig'
" Prereq for nvim-metals & typescript-tools
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Quickfix/loclist preview
Plug 'kevinhwang91/nvim-bqf'
Plug 'pmizio/typescript-tools.nvim'
Plug 'scalameta/nvim-metals'
call plug#end()
source ~/.vimrc

:lua << EOF
  -- Scala Metals configuration
  -----------------------------------------------------------------------------
  metals_config = require'metals'.bare_config()
  metals_config.settings = {
     showImplicitArguments = true,
     excludedPackages = {
       "akka.actor.typed.javadsl",
       "com.github.swagger.akka.javadsl"
     }
  }

  metals_config.on_attach = function()
    require'completion'.on_attach();
  end
  metals_config.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = false
    }
  )

  -- Treesitter Configuration
  -----------------------------------------------------------------------------
  require'nvim-treesitter.configs'.setup {
    highlight = {
      enable = true,

      ensure_installed = { "c", "groovy", "lua", "scala", "typescript" },

      sync_install = false,

      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = false,
    },
  }

  require("typescript-tools").setup {
    handlers = {
      ["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false }
      )
    },
    settings = {}
  }
EOF

if has('nvim')
  augroup lsp
    au!
    au FileType scala,sbt lua require('metals').initialize_or_attach(metals_config)
  augroup end
endif
