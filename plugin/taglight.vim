"
" taglight.vim
"
" Author:
"     Paul Meffle
"
" Summary:
"     Highlight tags generated by ctags.
"
" License:
"     Zlib license

if exists("g:loaded_taglight") || &cp
        finish
endif
let g:loaded_taglight = 1

augroup Taglight
        autocmd!
        autocmd Syntax cpp call taglight#HighlightTags()
        autocmd BufWritePost *.cpp,*.hpp,*.h call taglight#HighlightTags()
augroup END
