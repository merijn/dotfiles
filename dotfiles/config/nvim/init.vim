set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
call plug#begin()
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'kevinhwang91/nvim-bqf'
call plug#end()
source ~/.vimrc

:lua << EOF
  -- Treesitter Configuration
  -----------------------------------------------------------------------------
  require'nvim-treesitter.configs'.setup {
    highlight = {
      enable = true,

      ensure_installed = { "c", "groovy", "lua", "scala" },

      sync_install = false,

      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = false,
    },
  }
EOF
