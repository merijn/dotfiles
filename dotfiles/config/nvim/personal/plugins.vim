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
" Plugin Options                                                              "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Load Pathogen to deal with plugins
runtime bundle/vim-pathogen/autoload/pathogen.vim

call pathogen#infect()
" Rebuild database of help tags so pathogen plugin help works.
Helptags

" Ctrl-P options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_mruf_relative = 1
" Ignore files inside node_modules, .git, .hg, .svn, and .swp files
let g:ctrlp_custom_ignore = '\v[\/](node_modules|cache_puppeteer)|(\.(swp|ico|git|svn|hg|metals))|target$'

" Gundo options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:gundo_preview_bottom = 1
let g:gundo_right = 1
if has('python3')
    let g:gundo_prefer_python3 = 1
endif

" TagBar options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:tagbar_autoclose = 1
let g:tagbar_sort = 0

" ALE options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function s:shescape(string) abort
    return a:string =~# '\m^[A-Za-z0-9_/.-]\+$' ? a:string : shellescape(a:string)
endfunction

function FindLocalConfig(file, where)
    let cfg = findfile(a:file, escape(a:where, ' ') . ';')
    if cfg ==# ''
        return { 'lines' : [], 'root' : "" }
    endif

    let lines = readfile(cfg)
    " filter out empty lines and comments
    call filter(lines, 'v:val !~# ''\v^(\s*#|$)''')

    " remove leading and trailing spaces
    call map(lines, 'substitute(v:val, ''^\s\+'', "", "")')
    call map(lines, 'substitute(v:val, ''\s\+$'', "", "")')
    call map(lines, 's:shescape(v:val)')
    return { 'lines' : lines, 'root' : fnamemodify(cfg, ":p:h") . '/' }
endfunction

if has('nvim')
    " ALE has neovim diagnostics support enabled by default, so disable
    " updating loclist to avoid clashing/overriding vim diagnostics loclists
    let g:ale_set_loclist = 0
endif

" Don't show warnings as pseudo-comments
let g:ale_virtualtext_cursor = 'disabled'

let g:ale_change_sign_column_color = 0
let g:ale_keep_list_window_open = 0
let g:ale_list_vertical = 0
let g:ale_list_window_size = 10
let g:ale_loclist_msg_format = '%code: %%s [%linter%]'
let g:ale_max_signs = -1
let g:ale_open_list = 0

let g:ale_sign_column_always = 0
let g:ale_sign_error = '>>'
let g:ale_sign_info = '--'
let g:ale_sign_offset = 1000000
let g:ale_sign_style_error = '>>'
let g:ale_sign_style_warning = '--'
let g:ale_sign_warning = '--'
let g:ale_sign_highlight_linenrs = 0

let g:ale_echo_msg_format = "%code: %%s [%linter%]"
highlight ALEWarning cterm=underline

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
