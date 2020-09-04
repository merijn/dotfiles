highlight link texCommand texRefZone

let g:noSpellTexStatements = [
    \ "bibliographystyle", "setabbreviationstyle",
    \ "MoveCountersToOrFromLabel" ]

let g:noSpellTexCommandsInStatement = [
    \ "gls", "Gls", "glspl", "Glspl", "glsentrytext", "subfile"]

let g:noSpellTexCommandsInRefZone = ["labelref"]

function s:ignoreSpellHighlight(name, highlight, containedin, offset, ...)
    let args = a:0 ? a:0 : 1
    let texCmd = " \"\\\\" . a:name . "\\({[^}]\\{-}}\\)\\{" . l:args . "}\""
    let offsets = "hs=s+" . a:offset . ",he=e "
    let contains = "containedin=" . a:containedin . " contains=@NoSpell,texDelimiter"
    let cmdString = "syntax match " . a:highlight . l:texCmd . l:offsets . l:contains
    exec l:cmdString
endfunction

for stmt in g:noSpellTexStatements
    call s:ignoreSpellHighlight(stmt, "texStatement", "texStatement", 0)
endfor
call s:ignoreSpellHighlight("newabbreviation", "texStatement", "texStatement", 0, 3)

for cmd in g:noSpellTexCommandsInStatement
    let s:offset = 1 + len(cmd)
    call s:ignoreSpellHighlight(cmd, "texCommand", "texStatement", s:offset)
endfor

for cmd in g:noSpellTexCommandsInRefZone
    let s:offset = 1 + len(cmd)
    call s:ignoreSpellHighlight(cmd, "texCommand", "texRefZone", s:offset)
endfor
