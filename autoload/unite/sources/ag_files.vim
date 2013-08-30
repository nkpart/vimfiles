let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#ag_files#define()
  return s:source
endfunction

let s:source = {
      \ 'name' : 'ag_files',
      \ 'description' : 'ag for files',
      \ 'default_kind' : 'file',
      \ 'required_pattern_length' : 0,
      \ }

call extend(s:source, unite_util#EmptyGather())

function! s:source.change_candidates(args, context)
  let input = get(a:context, "input")
  let command = "ag -l --nocolor -g \"" . "\""
  let lines = split(system(command), '\n')
  let candidates = []
  for line in lines
    call add(candidates, unite_util#UniteFile(line))
  endfor
  return candidates
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
