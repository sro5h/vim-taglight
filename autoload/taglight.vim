" taglight.vim: Highligh tags generated by ctags.
" Author: Paul Meffle
" License: MIT License

" Get the path of the plugin root directory and the current working directory.
let s:script_directory = expand('<sfile>:p:h:h')
let s:working_directory = getcwd()

" Set the 'g:taglight_arguments' variable if not done by the user.
if !exists("g:taglight_arguments")
        let g:taglight_arguments="-d " . s:working_directory
endif

" Invokes the 'gen.bash' script and executes its output as vimscript. Also
" passes the current working directory as the directory to search for the tags
" file. The output is first saved in a temporary file generated by 'tempname()'.
function! taglight#HighlightTags()
        let temp_file = tempname()

        let output = system(s:script_directory . '/shell/gen.bash ' . g:taglight_arguments . ' > ' . l:temp_file)

        if v:shell_error != 0
                echoerr "gen.bash finished with an error"
                return
        endif

        execute "source " . l:temp_file
endfunction
