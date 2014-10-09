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
set shortmess+=I                "Disable showing splash screen

let mapleader = "\<C-g>"        "Map leader key
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
    set guioptions-=r               "Right-hand scrollbar always present
    set guioptions-=R               "Right-hand scrollbar present in split-window
    set guioptions-=l               "Left-hand scrollbar always present
    set guioptions-=L               "Left-hand scrollbar present in split-window
    set hlsearch                "Highlight all search matches if color is
endif                           "possible (:noh to toggle off)

set gdefault                    "Substitution affect all matches on a line
"Remap return key to toggle highlight off when pressing enter in command mode.
nnoremap <silent> <return> :noh<return>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File browsing options                                                       "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Ignore various binary file types when completing file names
set wildignore+=*.o,*.lo,*.la,*.a,*.so,.*.d,*.pyc,.DS_Store,*.aux,*.bbl,*.blg
set wildignore+=*.lof,*.log,*.lot,*.toc,*.pdf,*.hi,*.p_o,*.p_hi,*.dyn_hi
set wildignore+=*.dyn_o

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
        autocmd BufNewFile,BufRead CMakeLists.txt setlocal nospell
        autocmd BufNewFile,BufRead CMakeLists.txt setlocal number
    endif
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Language detection                                                          "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
" Misc options & commands                                                     "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! StripWhitespace :%s/\s\+$//

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Options                                                              "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Load Pathogen to deal with plugins
runtime bundle/vim-pathogen/autoload/pathogen.vim

call pathogen#infect()

" Ctrl-P options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <Leader>t :CtrlPMixed<return>
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_mruf_relative = 1

" Gundo options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <F1> :GundoToggle<CR>
let g:gundo_preview_bottom = 1
let g:gundo_right = 1

" TagBar options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <F2> :TagbarToggle<CR>
let g:tagbar_autoclose = 1
let g:tagbar_sort = 0

" Syntastic options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:syntastic_enable_highlighting = 1
let g:syntastic_echo_current_error = 0
let g:syntastic_error_list_is_open = 0
let g:syntastic_mode_map = { 'mode': 'active',
                           \ 'active_filetypes': [],
                           \ 'passive_filetypes': ['tex'] }

function! GetNextSyntasticError(next)
    " If there's only one error, jump to it.
    if len(getloclist(0)) == 0
    elseif len(getloclist(0)) == 1
        ll
    " Else, if we're going forward, jump to the next error.
    elseif a:next
        lnext
    " Else, jump to the previous error.
    else
        lprev
    endif
endfunction

function! ToggleSyntasticErrorList()
    if g:syntastic_error_list_is_open
        " This should use lclose, as Synastic uses the location list. However,
        " for some reason lclose doesn't close it, but cclose does. Go with
        " what works.
        cclose
        " Added lclose too, as for some bizarre reason cclose does not work on
        " the DAS-4 linux boxes.
        lclose
        let g:syntastic_error_list_is_open = 0
    else
        " Open the Syntastic error window.
        Errors
        let g:syntastic_error_list_is_open = 1
    endif
endfunction

nnoremap <silent> <C-j> :call GetNextSyntasticError(1)<CR>
nnoremap <silent> <C-k> :call GetNextSyntasticError(0)<CR>
nnoremap <silent> \ :call ToggleSyntasticErrorList()<return>

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
    \ ['red',         'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['gray',        'RoyalBlue3'],
    \ ]

augroup RainbowParentheses
    au VimEnter * RainbowParenthesesToggle
    au Syntax * RainbowParenthesesLoadRound
    au Syntax * RainbowParenthesesLoadSquare
augroup END
