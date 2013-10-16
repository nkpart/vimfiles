function! CommitChanges(commit)
  let [commit] = matchlist(a:commit, '\v(.{,7})\s(.*)$')[1:1]
  call SelectaCommand("git diff-tree --no-commit-id --name-only -r " . commit, ":e")
endfunction

function! CommandTListChanges()
  call SelectaFunction("git log --oneline --decorate -n 15", "CommitChanges")
endfunction

function! GemfileSelecta()
  call SelectaFunction('bundle list | grep "*"', "SelectedGem")
endfunction

function! SelectedGem(gem)
  let [gem_name] = matchlist(a:gem,'\v\*\s*(.*)\s+\(.*')[1:1]
  let dir = system("bundle show " . gem_name)
  exec "Sexplore " . dir . " | lcd " . dir
endfunction

function! ShowSchemaFinder()
  call BijectaFunction("ag --nocolor create_table db/schema.rb", "\\\"(.*)\\\"", "GoToTable")
endfunction

function! GoToTable(tableLine)
  let [lineno, text] = matchlist(a:tableLine,'\v(\d+):(.*)$')[1:2]
  exe "silent edit +" . lineno . " db/schema.rb"
  normal zt
endfunction
