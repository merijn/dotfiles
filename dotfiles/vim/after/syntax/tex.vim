highlight link texCommand texRefZone

for cmd in ["gls", "Gls", "glspl", "Glspl"]
    exec "syntax match texCommand \"\\\\" . cmd . "{[^}]\\{-}}\"hs=s+4,he=e containedin=texStatement contains=@NoSpell,texDelimiter"
endfor