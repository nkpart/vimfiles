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
    let [fname, lineno, text] = matchlist(line,'\v(.{-}):(\d+):(.*)$')[1:3]
    call add(candidates, {
          \ "word": fname . ":" . lineno . ":" . text,
          \ "source": "ag",
          \ "kind": "jump_list",
          \ "action__path": fname,
          \ "action__line": lineno,
          \ "action__text": text,
          \ } )
  endfor
  return candidates
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
