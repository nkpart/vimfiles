let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#hoogle#define()
  return s:source
endfunction

let s:source = {
      \ 'name' : 'hoogle',
      \ 'description' : 'hoogle for things',
      \ 'default_kind' : 'file',
      \ 'default_action' : 'picked',
      \ 'action_table' : {},
      \ 'required_pattern_length' : 2,
      \ }

let s:source.action_table.picked = { 'is_quit' : 1 }
function! s:source.action_table.picked.func(candidates)
endfunction

call extend(s:source, unite_util#EmptyGather())

function! s:source.change_candidates(args, context)
  let input = get(a:context, "input")
  " TODO Allow refining of packages:
    " _,modules,_,str = *str.match(/((\+[a-z,\-]+\s)*)(.*)/)
    " %`hoogle #{modules} -n 10 "#{str}"` 
  let command = "hoogle -n 10 \"" . input . "\""
  let result = split(unite#util#system(command), '\n')
  let results = map(result, "{
        \ 'word' : v:val
        \ }")
  return results
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
