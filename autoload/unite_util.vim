function! unite_util#EmptyGather()
  let v = {}
  function! v.gather_candidates(args, context)
    return []
  endfunction
  return v
endfunction
