" Send the output of rg to the quickfix window
command! -nargs=+ Rg execute 'silent grep! <args>' | cwindow

" Strip all trailing whitespace in a file
command! -range=% StripWhitespace :%s/\s\+$//

" Create a new file in the same directory as the current file
command! -nargs=1 New :execute "e" expand('%:p:h') . '/<args>'

" Show how the syntax for the word under the cursor is decided
if has('nvim')
  command! ShowSyntax :Inspect
else
  command! ShowSyntax :echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endif

" Show the highlight rules for the word under the cursor
command! ShowHighlight :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
            \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
            \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"
