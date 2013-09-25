let s:save_cpo = &cpo
set cpo&vim

function! unite#filters#matcher_matcher#define() "{{{
  return s:matcher
endfunction"}}}

" call unite#util#set_default('g:unite_matcher_fuzzy_max_input_length', 20)

let s:matcher = {
      \ 'name' : 'matcher_matcher',
      \ 'description' : 'matcher matcher',
      \}

function! s:matcher.filter(candidates, context) "{{{
  if a:context.input == ''
    return unite#filters#filter_matcher(
          \ a:candidates, '', a:context)
  endif

  let cs = {}
  let ws = []

  for candidate in a:candidates
    let word = candidate["word"]
    call add(ws, word)
    let cs[word] = candidate
  endfor

  let cmd = "matcher --limit 10 " . a:context.input
  let sorted = split(system(cmd, join(ws, "\n")), "\n")
  let output = []
  for word in sorted
    call add(output, cs[word])
  endfor
  return output
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
