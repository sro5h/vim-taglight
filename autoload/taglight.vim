"
" taglight.vim - 0.2.1
"
" Author:
"     Paul Meffle
"
" Summary:
"     Highlight tags generated by ctags.
"
" Changelog:
"     0.1.0 (25.07.2017) initial release
"     0.2.0 (25.07.2017) join -f and -d options
"     0.2.1 (13.09.2017) cleanup and update documentation
"
" License:
"     Zlib license

if exists('g:autoloaded_taglight')
        finish
endif
let g:autoloaded_taglight = 1

" Get the path of the plugin root directory and the current working directory.
let s:script_directory = expand('<sfile>:p:h:h')
let s:working_directory = getcwd()
let s:tags_file = "tags"

" Set the 'g:taglight_arguments' variable if not done by the user.
if !exists("g:taglight_arguments")
        let g:taglight_arguments="-f " . s:working_directory . "/" . s:tags_file
endif

" Invokes the 'gen.bash' script and executes its output as vimscript. Also
" passes the current working directory as the directory to search for the tags
" file. The output is first saved in a temporary file generated by 'tempname()'.
function! taglight#HighlightTags() abort
        let temp_file = tempname()

        let output = system(s:script_directory . '/shell/gen.bash ' . g:taglight_arguments . ' > ' . l:temp_file)

        if v:shell_error != 0
                echoerr "gen.bash finished with an error"
                return
        endif

        execute "source " . l:temp_file
endfunction
