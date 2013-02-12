"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible                "Turn off vi compatibility
set langmenu=none               "Set all the menu's to use English
colorscheme delph               "Use custom colour scheme
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
set clipboard+=unnamed          "Let me paste directly from Windows clipboard
set lazyredraw                  "Don't update screen during macro's, etc.
if has("mouse")
    set mouse=a                 "Allow mouse in all modes except insert
endif
set confirm                     "Prompt save confirmation instead of returning
                                "error for command

let mapleader = "\<C-g>"             "Map leader key
"Y behaves as D and C rather than yy
noremap Y y$

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
nnoremap <return> :noh<return>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File browsing options                                                       "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Ignore various binary file types when completing file names
set wildignore+=*.o,*.lo,*.la,*.a,*.so,.*.d,*.pyc,.DS_Store,*.aux,*.bbl,*.blg
set wildignore+=*.lof,*.log,*.lot,*.toc,*.pdf,*.hi

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Programming options                                                         "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set number                      "Enable line numbers

if &t_Co > 2 || has("gui_running")
    syntax on                   "Turn on syntax highlighting
endif

" Folding options
if version >= 600
    set foldenable              "Enable folding if available
    set foldmethod=syntax       "Fold on syntax
    set foldopen=block,hor,insert,jump,mark,percent,undo
    set foldclose=all
endif

if has("autocmd")
    autocmd BufNewFile,BufRead */work/advance/* setlocal sts=2 sw=2
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Miscellaneous options                                                       "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if &t_Co > 2 || has("gui_running")  "Match characters past column 79 to mark
    match LineTooLong /\%>79v.\+/   "as red.
endif

" English spell checking, turn off by default except for TeX/LaTeX files.
if version >= 700
    set spl=en spell
    set nospell
    if has("autocmd")
        autocmd BufNewFile,BufRead *.rst,*.txt,*.tex,*.latex setlocal spell
        autocmd BufNewFile,BufRead *.rst,*.txt,*.tex,*.latex setlocal nonumber
    endif
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Language options                                                            "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if &t_Co > 2 || has("gui_running")
    let python_highlight_all = 1 "Enable highlighting all python syntax
endif

if has("autocmd")
    au BufReadPost *.rkt,*.rktl set filetype=racket
    au filetype racket set lisp
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GUI options                                                                 "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("gui_running")
  if has("unix")
    let s:uname = system("uname")
    " Use Monaco font on OS X
    if s:uname =~ "Darwin"
        set guifont=Monaco:h14
    endif
  endif
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Options                                                              "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Load Pathogen to deal with plugins
runtime bundle/vim-pathogen/autoload/pathogen.vim

call pathogen#infect()

" Command-T options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Bind Ctrl-T to Command-T extension
nnoremap <C-t> :CommandT<return>
nnoremap <Leader>t :CommandT<return>

if &term =~ "xterm"
  let g:CommandTCancelMap     = ['<ESC>', '<C-g>']
  let g:CommandTBackspaceMap  = ['<BS>', '<C-h>']
  let g:CommandTSelectNextMap = ['<C-n>', '<C-j>', '<ESC>OB']
  let g:CommandTSelectPrevMap = ['<C-p>', '<C-k>', '<ESC>OA']
endif

if &term =~ "xterm-256color"
  let g:CommandTCancelMap     = ['<ESC>', '<C-g>']
  let g:CommandTBackspaceMap  = ['<BS>', '<C-h>']
  let g:CommandTSelectNextMap = ['<C-n>', '<C-j>', '<ESC>OB']
  let g:CommandTSelectPrevMap = ['<C-p>', '<C-k>', '<ESC>OA']
endif

if &term =~ "screen"
  let g:CommandTCancelMap     = ['<ESC>', '<C-g>']
  let g:CommandTBackspaceMap  = ['<BS>', '<C-h>']
  let g:CommandTSelectNextMap = ['<C-n>', '<C-j>', '<ESC>OB']
  let g:CommandTSelectPrevMap = ['<C-p>', '<C-k>', '<ESC>OA']
endif

" Gundo options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <F1> :GundoToggle<CR>
let g:gundo_preview_bottom = 1
let g:gundo_right = 1

" TagList options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <F2> :TlistToggle<CR>
let g:Tlist_GainFocus_On_ToggleOpen = 1
let g:Tlist_Close_On_Select = 1
let g:Tlist_Inc_Winwidth = 1

" Syntastic options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:syntastic_enable_highlighting = 1
let g:syntastic_echo_current_error = 0

" Rainbow Parentheses options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['white',       'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ]

let rainbow = ['haskell', 'racket', 'lisp']

if has("autocmd")
    autocmd BufCreate,BufEnter * if index(rainbow, &ft) >= 0 | NoMatchParen
    autocmd BufCreate,BufEnter * if index(rainbow, &ft) >= 0 | RainbowParenthesesToggle
    autocmd BufDelete,BufLeave * if index(rainbow, &ft) >= 0 | DoMatchParen
    autocmd BufDelete,BufLeave * if index(rainbow, &ft) >= 0 | RainbowParenthesesToggle
endif

" Vim-slime options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:slime_target = "tmux"
let g:slime_paste_file = tempname()
