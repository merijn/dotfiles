set runtimepath^=~/.vim runtimepath+=~/.vim/after
call plug#begin()
" Git history interaction
Plug 'tpope/vim-fugitive'

if !has('nvim') " Vim only plugins
    runtime personal/vim/plugins.vim
else " Neovim only plugins
    runtime personal/nvim/plugins.vim
endif
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Helper functions                                                            "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function s:isOSX()
    if has("unix")
        let s:uname = system("uname")
        " Use Monaco font on OS X
        if s:uname =~ "Darwin"
            return 1
        endif
    endif
    return 0
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set langmenu=none               "Set all the menu's to use English
if &t_Co >= 256 || has("gui_running")
    colorscheme delph256        "Use custom 256 colour scheme
else
    colorscheme delph           "Use custom minimal colour scheme
endif
if has("autocmd")
    "Clear all autocommands to avoid duplicates, has to be on empty line
    autocmd!
    filetype plugin indent on   "Load filetype specific plugins and indent file
endif
set nomodeline                  "Exploitable, should be off
set ruler                       "Show cursor position
set hidden                      "Don't force me to save before changing buffers
set list                        "Show hidden characters
set listchars=tab:»»,trail:·    "What to show instead of characters
set magic                       "Commands treat backslash escaped chars as
                                "control chars
set clipboard+=unnamed          "Let me paste directly from the OS clipboard
set lazyredraw                  "Don't update screen during macro's, etc.
if has("mouse")
    set mouse=a                 "Allow mouse in all modes except insert
endif
set confirm                     "Prompt save confirmation instead of returning
                                "error for command
set shortmess+=I                "Disable showing splash screen
set belloff=esc,backspace       "Don't play bell sound on ESC in normal mode or
                                "backspace error

" Don't show statusline ever, it's just clutter
set laststatus=0
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Edit options                                                                "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set scrolloff=5                 "Keep this many lines visible at top/bottom
set bs=indent,eol,start         "Turn on backspace in insert mode
set textwidth=79                "Maximum linewidth
set wildmenu                    "Show all auto-completion options
" Tab specific option
set tabstop=8                   "A tab is 8 spaces
set expandtab                   "Always uses spaces instead of tabs
set softtabstop=4               "Insert 4 spaces when tab is pressed
set shiftwidth=4                "An indent is 4 spaces
set smarttab                    "Indent instead of tab at start of line
set shiftround                  "Round spaces to nearest shiftwidth multiple
set nojoinspaces                "Don't convert spaces to tabs

set formatoptions=cjnqr         "Controls how text and comments are formatted
"Regular expression to detect the start of numbered lists in comments and text
"files.
let &formatlistpat='^\s+\(\d\+[\]:.)}\t ]\|[\*+-@#]\)\s*'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Search options                                                              "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set ignorecase                  "Turn of case sensitivity
set smartcase                   "Only enable above for strings in all lowercase
set incsearch                   "Search while typing query
if &t_Co > 2 || has("gui_running")
    set hlsearch                "Highlight all search matches if color is
endif                           "possible (:noh to toggle off)

set gdefault                    "Substitution affect all matches on a line
"Remap return key to toggle highlight off when pressing enter in command mode.
nnoremap <silent> <return> :noh<return>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File browsing options                                                       "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Ignore various binary file types, LaTeX files, generated files, version
"control folders, and various build folders when completing file names
set wildignore+=*.o,*.lo,*.la,*.a,*.so,.*.d,*.pyc,.DS_Store,*.aux,*.bbl,*.blg
set wildignore+=*.lof,*.log,*.lot,*.toc,*.pdf,*.hi,*.p_o,*.p_hi,*.dyn_hi
set wildignore+=*.dyn_o,*/.git/*,*/.svn/*,*/.hg/*,*/dist/*,*.dSYM/*,*.d
set wildignore+=*/dist-newstyle/*,*/build/*,*.class

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Programming options                                                         "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Only do the following outside of vimdiff
if !&diff
    set number                      "Enable line numbers
endif

if &t_Co > 2 || has("gui_running")
    syntax on                   "Turn on syntax highlighting
endif

" Folding options
if version >= 600
    set foldenable              "Enable folding if available
    set foldmethod=syntax       "Fold on syntax
    set foldopen=block,hor,insert,jump,mark,percent,quickfix,undo
    set fillchars+=fold:\ 
    set foldminlines=3
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Miscellaneous options                                                       "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if !&diff && (&t_Co > 2 || has("gui_running"))  "Match characters past column
    match LineTooLong /\%>79v.\+/               "79 to mark as red.
endif

" Use rg for :grep if it's installed
if executable("rg")
    let &grepprg="rg --vimgrep --trim"
    let &grepformat="%f:%l:%c:%m"
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GUI options                                                                 "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("gui_running")
    set guioptions-=r   "Disable right-hand scrollbar
    set guioptions-=R   "Disable split-window right-hand scrollbar
    set guioptions-=l   "Disable left-hand scrollbar
    set guioptions-=L   "Disable split-window left-hand scrollbar present

    if s:isOSX()
        set guifont=Monaco:h14
    endif
endif

let mapleader = "\<C-g>"        "Map leader key
"Y behaves as D and C rather than yy
noremap Y y$

"Make Ctrl-A a noop so it doesn't conflict with tmux mapping and clobber
"numbers all over
noremap <silent> <C-A> <Nop>


source ~/.vimrc
runtime nvim/config.lua
