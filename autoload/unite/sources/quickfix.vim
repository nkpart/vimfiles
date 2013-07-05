let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#quickfix#define()
  return s:source
endfunction

let s:source = {
      \ 'name' : 'quickfix',
      \ 'default_kind' : 'file'
      \ }

call extend(s:source, unite_util#EmptyGather())

function! s:source.gather_candidates(args, context)
  let candidates = []
  for error in getqflist()
    let fname = bufname(error.bufnr)
    let lineno = error.lnum
    let text = error.text
    call add(candidates, {
          \ "word": fname . ":" . lineno . ":" . text,
          \ "source": "error_file",
          \ "kind": "jump_list",
          \ "action__path": fname,
          \ "action__line": lineno,
          \ "action__text": text,
          \ })
  endfor
  return candidates
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
