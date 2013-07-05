let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#ag#define()
  return s:source
endfunction

let s:source = {
      \ 'name' : 'ag',
      \ 'description' : 'ag as you type',
      \ 'default_kind' : 'file',
      \ 'required_pattern_length' : 4,
      \ }

call extend(s:source, unite_util#EmptyGather())

function! s:source.change_candidates(args, context)
  let input = get(a:context, "input")
  let command = "ag --nocolor --nogroup --search-files \"" . input . "\""
  let lines = split(unite#util#system(command), '\n')
  "Source: https://github.com/t9md/vim-unite-ack/blob/master/autoload/unite/sources/ack.vim#L54
  let candidates = []
  for line in lines
    call add(candidates, unite_util#AgLineParser(line))
  endfor
  return candidates
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
