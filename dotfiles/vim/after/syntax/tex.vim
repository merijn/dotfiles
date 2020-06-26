highlight link texCommand texRefZone

let g:noSpellTexStatements = [ "bibliographystyle", "setabbreviationstyle" ]
let g:noSpellTexCommands = [
    \ "gls", "Gls", "glspl", "Glspl", "glsentrytext", "subfile",
    \ "llabel" ]

function s:ignoreSpellHighlight(name, highlight, offset, ...)
    let args = a:0 ? a:0 : 1
    let texCmd = " \"\\\\" . a:name . "\\({[^}]\\{-}}\\)\\{" . l:args . "}\""
    let offsets = "hs=s+" . a:offset . ",he=e "
    let contains = "containedin=texStatement contains=@NoSpell,texDelimiter"
    let cmdString = "syntax match " . a:highlight . l:texCmd . l:offsets . l:contains
    exec l:cmdString
endfunction

for stmt in g:noSpellTexStatements
    call s:ignoreSpellHighlight(stmt, "texStatement", 0)
endfor
call s:ignoreSpellHighlight("newabbreviation", "texStatement", 0, 3)

for cmd in g:noSpellTexCommands
    let s:offset = 1 + len(cmd)
    call s:ignoreSpellHighlight(cmd, "texCommand", s:offset)
endfor
