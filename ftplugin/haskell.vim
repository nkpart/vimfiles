set path+=templates,src 
set suffixesadd+=.hamlet
setlocal omnifunc=necoghc#omnifunc

nnoremap <leader>/ :GhcModTypeClear<cr>
nnoremap <leader>. :GhcModType<cr>
nnoremap <leader>T :GhcModTypeInsert<cr>
nnoremap <leader>c :wa<cr>:GhcModCheckAsync<cr>

set iskeyword=a-z,A-Z,_,.,39 " For hothasktags, tags can be qualified
