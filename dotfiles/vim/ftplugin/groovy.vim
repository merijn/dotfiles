match none
if !&diff && (&t_Co > 2 || has("gui_running"))  "Match characters past column
    match LineTooLong /\%>159v.\+/              "159 to mark as red.
endif