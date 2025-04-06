set runtimepath^=~/.vim runtimepath+=~/.vim/after

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Spellcheck options                                                          "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" English spell checking, turn off by default except for TeX/LaTeX files.
if version >= 700
    " Run manually to fetch spellfiles from vim FTP server
    set spelllang=en_gb,nl spell
    set nospell

    augroup SpellAutoGroup
        autocmd!
        autocmd BufNewFile,BufRead *.rst,*.txt,*.tex,*.latex call personal#spell#SetSpelling(expand('<afile>:p:h'))
    augroup END
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Quickfix List Functions                                                     "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function SetLocList(info)
    if a:info.quickfix
        let items = getqflist({'id' : a:info.id, 'items': 1}).items
    else
        let items = getloclist(a:info.winid, {'id' : a:info.id, 'items': 1}).items
    endif

    let l = []
    for idx in range(a:info.start_idx - 1, a:info.end_idx - 1)
        let item = items[idx]

        let msg = ''

        if item.type
            let msg .= item.type . '|'
        endif

        if a:info.quickfix
            let msg .= fnamemodify(bufname(item.bufnr), ':p:.') . '|'
        endif

        if item.lnum && item.lnum > 0
            let msg .= item.lnum

            if item.col && item.col > 0
                let msg .= ':' . item.col
            endif

            if item.end_col && item.end_col > 0
                let msg .= '-'
                if item.end_lnum && item.end_lnum > item.lnum
                    let msg .= item.end_lnum . ':'
                endif
                let msg .= item.end_col
            endif
        endif

        let msg .= '| ' . substitute(item.text, '\n\s*', ' ', 'g')

        call add(l, msg)
    endfor

    return l
endfunction
set quickfixtextfunc=SetLocList

function ToggleQuickFix()
    " If a quickfix list is open, close it and exit function
    for winnr in range(1, winnr('$'))
        if getwinvar(winnr, '&syntax') == 'qf'
            cclose
            return
        endif
    endfor

    " Update quickfix diagnostics
    lua vim.diagnostic.setqflist()

    " No open quickfix list to close, open it if not empty
    if len(getqflist()) != 0
        copen
    endif
endfunction

function ToggleErrorList()
    " Check if loclist is open
    if get(getloclist(0, {'winid':0}), 'winid', 0)
        lclose
    elseif len(getloclist(0)) != 0
        " Open the location list
        lopen
        " Jump back to previously active window, so loclist preview does not
        " appear
        wincmd p
    else
        call ToggleQuickFix()
    endif
endfunction

runtime personal/plugins.vim
if has('nvim')
    runtime personal/nvim/config.lua
endif
runtime personal/keybindings.vim
runtime personal/commands.vim
