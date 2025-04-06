let s:globalSpellingUpdate = 0

function! personal#spell#CheckSpellFileUpToDate(file)
    if filereadable(a:file) && (!filereadable(a:file . '.spl') || getftime(a:file) > getftime(a:file . '.spl'))
        exec 'mkspell! ' . fnameescape(a:file)
    endif
endfunction

function! s:SetGlobalSpelling()
    if s:globalSpellingUpdate
        return
    endif

    let spellfiles = glob('~/.vim/spell/*.add', 1, 1)
    let l:spellfiles += glob('~/.config/nvim/spell/*.add', 1, 1)

    " Check if binary spell files are outdated and rebuild if necessary
    for d in l:spellfiles
        call personal#spell#CheckSpellFileUpToDate(d)
    endfor

    let s:globalSpellingUpdate = 1
endfunction

" Loads spelling additions from the directory of the file we're editing
function! s:SetLocalSpelling(path)
    let spellfiles = []
    let where = a:path

    while l:where != '/' && l:spellfiles == []
        let l:spellfiles = globpath(l:where, "*.add", 0, 1)
        if l:spellfiles == []
            let l:where = fnamemodify(l:where, ":h")
        endif
    endwhile

    for d in l:spellfiles
        call personal#spell#CheckSpellFileUpToDate(d)
    endfor
    let &spellfile=join(l:spellfiles, ',')
endfunction

function! personal#spell#SetSpelling(file)
    let fileName = fnamemodify(a:file, ":t")

    " Abort early if the file in question is CMakeLists.txt or a help file,
    " since we don't want to spellcheck those.
    if l:fileName == "CMakeLists.txt"
        return
    endif

    call s:SetGlobalSpelling()
    call s:SetLocalSpelling(fnamemodify(a:file, ":p:h"))

    setlocal spell
    setlocal formatoptions+=t
endfunction
