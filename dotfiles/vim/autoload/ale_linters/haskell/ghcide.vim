call ale#Set('haskell_ghcide_executable', 'ghcide')

function! ale_linters#haskell#ghcide#GetProjectRoot(buffer) abort
    let l:project_file = ale#path#FindNearestFile(a:buffer, 'hie.yaml')

    if empty(l:project_file)
        let l:project_file = ale#path#FindNearestFile(a:buffer, 'cabal.project')
    endif

    if empty(l:project_file)
        let l:paths = ale#path#Upwards(expand('#' . a:buffer . ':p:h'))[:-2]
        for path in l:paths
            let l:cabalFiles = globpath(l:path, "*.cabal", 1, 1)
            if len(l:cabalFiles)
                let l:project_file = l:cabalFiles[0]
                break
            endif
        endfor
    endif

    if empty(l:project_file)
        let l:project_file = ale#path#FindNearestFile(a:buffer, 'stack.yaml')
    endif

    " If we still can't find one, use the current file.
    if empty(l:project_file)
        let l:project_file = expand('#' . a:buffer . ':p')
    endif

    return fnamemodify(l:project_file, ':h')
endfunction
