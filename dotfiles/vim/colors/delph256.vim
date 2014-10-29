" Clear existing highlights, set background dark and set the color scheme name
hi clear
set background=dark
let g:colors_name = "delph256"

" Reset syntax highlighting colors
if exists("syntax_on")
  syntax reset
endif

hi Comment                  ctermfg=69      guifg=#5F87FF
hi Constant                 ctermfg=124     guifg=#AF0000
    hi link Boolean         Constant
    hi link Character       Constant
    hi link Number          Constant
        hi link Float       Number
    hi link String          Constant

hi Cursor                                               guifg=#000000   guibg=#00FF00
hi CursorColumn             ctermbg=242                                 guibg=#6C6C6C
hi CursorLine               cterm=underline                             guibg=#6C6C6C
hi Directory                ctermfg=159                 guifg=#AFFFFF
hi Error                    ctermfg=15      ctermbg=9   guifg=#FFFFFF   guibg=#FF5555
hi ErrorMsg                 ctermfg=15      ctermbg=1   guifg=#FFFFFF   guibg=#BB0000
hi Folded                   ctermfg=14      ctermbg=242 guifg=#55FFFF   guibg=#6C6C6C
hi Identifier               ctermfg=14                  guifg=#55FFFF
    hi link Function        Identifier

hi LineNr                   ctermfg=11                  guifg=#FFFF55
hi LineTooLong              ctermfg=0       ctermbg=1   guifg=#000000   guibg=#BB0000
hi MatchParen               ctermbg=6                                   guibg=#00BBBB
"hi Menu
hi ModeMsg                  cterm=bold      gui=bold
hi MoreMsg                  ctermfg=2                   guifg=#00BB00
hi NonText                  ctermfg=12                  guifg=#5555FF
hi Normal                   ctermfg=7                   guifg=#BBBBBB   guibg=#000000
hi PreProc                  ctermfg=5                   guifg=#BB55BB
    hi link Define          PreProc
    hi link Include         PreProc
    hi link Macro           PreProc
    hi link PreCondit       PreProc

hi Question                 ctermfg=2                   guifg=#00BB00
"hi Scrollbar
hi Search                   cterm=reverse   ctermfg=None    ctermbg=0
hi Search                   gui=reverse     guifg=NONE      guibg=#000000
hi Special                  ctermfg=130     guifg=#AF5F00
    hi link Debug           Special
    hi link Delimiter       Special
    hi link SpecialChar     Special
    hi link SpecialComment  Special
    hi link Tag             Special

hi SpecialKey               ctermfg=1       guifg=#BB0000
" Spelling error
hi SpellBad         cterm=reverse   ctermbg=9       gui=reverse     guibg=#FF5555
" Capitalisation error
hi SpellCap         cterm=reverse   ctermbg=12      gui=reverse     guibg=#5555FF
" Wrong language
hi SpellLocal       cterm=reverse   ctermbg=14      gui=reverse     guibg=#55FFFF
" Uncommon word
hi SpellRare        cterm=reverse   ctermbg=13      gui=reverse     guibg=#FF55FF

hi Statement                ctermfg=130     guifg=#AF5F00
    hi link Conditional     Statement
    hi link Exception       Statement
    hi link Keyword         Statement
    hi link Label           Statement
    hi link Operator        Statement
    hi link Repeat          Statement

hi StatusLine               cterm=reverse   ctermfg=12      ctermbg=15  guifg=#5555FF   guibg=#FFFFFF
hi StatusLineNC             cterm=reverse   gui=reverse
hi TabLine                  cterm=underline ctermfg=15      ctermbg=242 gui=underline   guifg=#FFFFFF   guibg=#6C6C6C
hi TabLineFill              cterm=reverse   gui=reverse
hi TabLineSel               cterm=bold      gui=bold
hi Title                    ctermfg=225     guifg=#FFD7FF
hi Todo                     ctermfg=0       ctermbg=11  guifg=#000000   guibg=#FFFF55
hi Type                     ctermfg=2       guifg=#00BB00
    hi link StorageClass    Type
    hi link Structure       Type
    hi link Typedef         Type

hi Visual                   ctermbg=242     guibg=#6C6C6C
    hi link IncSearch       Visual

hi WarningMsg               ctermfg=224     guifg=#FFD7D7
