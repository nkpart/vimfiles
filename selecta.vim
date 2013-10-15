" Run a given vim command on the results of fuzzy selecting from a given shell
" command. See usage below.
function! SelectaCommand(choice_command, vim_command)
  call TidilyExec(a:vim_command . " " . system(a:choice_command . " | selecta"))
endfunction

function! SelectaCommand2(input, vim_command)
  call TidilyExec(a:vim_command . " " . system("selecta", join(a:input, "\n")))
endfunction

function! ProducaCommand(choice_command, vim_command)
  call TidilyExec(a:vim_command . " " . system("produca " . a:choice_command))
endfunction

function! TidilyExec(vim_command)
  try
    silent! exec a:vim_command
  catch /Vim:Interrupt/
    " Swallow the ^C so that the redraw below happens; otherwise there will be
    " leftovers from selecta on the screen
  endtry
  redraw!
endfunction
