let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#git_status#define()
  return s:source
endfunction

let s:source = {
      \ 'name' : 'git_status',
      \ 'description' : 'ag as you type',
      \ 'default_kind' : 'file',
      \ }

function! s:source.gather_candidates(args, context)
  let command = "git status -s --porcelain"
  let lines = split(unite#util#system(command), '\n')
  let candidates = []
  for line in lines
    let [fname] = matchlist(line,'\v.*\s+(.*)$')[1:1]
    call add(candidates, {
          \ "word": fname,
          \ "source": "git_status",
          \ "kind": "jump_list",
          \ "action__path": fname,
          \ } )
  endfor
  return candidates
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
