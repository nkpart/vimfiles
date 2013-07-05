function! unite_util#EmptyGather()
  let v = {}
  function! v.gather_candidates(args, context)
    return []
  endfunction
  return v
endfunction

function! unite_util#AgLineParser(line)
    let [fname, lineno, text] = matchlist(a:line,'\v(.{-}):(\d+):(.*)$')[1:3]
    return {
          \ "word": fname . ":" . lineno . ":" . text,
          \ "source": "ag",
          \ "kind": "jump_list",
          \ "action__path": fname,
          \ "action__line": lineno,
          \ "action__text": text,
          \ }
endfunction
