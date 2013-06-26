ruby <<RUBY
$LOAD_PATH << File.expand_path("~/.vim/ruby")
require "command-t-finders"
RUBY

function! CommandTChanges()
  let shaname = input("SHA: ", "HEAD")
  CommitChanges(shaname)
endfunction

function! CommitChanges(commit)
ruby << RUBY
  files = `git diff-tree --no-commit-id --name-only -r #{::VIM::evaluate("a:commit")}`.chomp.split("\n")
  Finder.present do
    match_list(files)
    open_selection_
  end
RUBY
endfunction

function! CommandTListChanges()
ruby << RUBY
  commits = `git log --oneline --decorate -n 15`.chomp.split("\n")
  Finder.present do
    match_list(commits)
    vim_handler { |sel|
      ":call CommitChanges(\"#{sel.split.first}\")"
    }
  end
RUBY
endfunction

function! CommandTShowGemfileFinder()
ruby << RUBY
  pwd = ::VIM::evaluate 'getcwd()'
  gems = IO.read(File.join(pwd, "Gemfile.lock"))[/specs:(.*)PLATFORMS/m,1].
    split("\n").
    grep(/\s\s\s\s.*\(\d\..*\)/). # '    gem-name (1.1.1)'
    map { |x| x.strip }
  Finder.present do
    match_list(gems)
    vim_handler { |selection|
      gem_name = selection[/\s*(.*)\s*\(.*/, 1]
      dir = `bundle show #{gem_name}`.chomp
      "Sexplore #{dir} | lcd #{dir}"
    }
  end
RUBY
endfunction

function! CommandTShowMyTagFinder()
ruby << RUBY
Finder.present do
  generate_with { |str| 
    if !str || str.length < 3
      ""
    else
      a, b = *str.split(' ')
      tag, file = *(b ? [b, a] : [a, nil])
      if !tag || tag.length < 3
        ""
      else
        VIM::evaluate("taglist(#{tag.inspect})").select { |x| !file || x['filename'].include?(file) }.map { |t| 
          t['name'] + " - " + t['filename'].gsub(Dir.pwd + '/', '')#.gsub(/.*\/gems\//, '') 
        }
      end
    end
  }
  vim_handler { |selection|
    md = selection.match(/(.*) - (.*)/)
    tag = md[1]
    file = md[2] 
    "silent! e #{file} | silent! tag #{tag} | normal zz"
  }
end
RUBY
endfunction

function! ShowSchemaFinder()
ruby << RUBY
  pwd = ::VIM::evaluate 'getcwd()'
  tables = IO.read(File.join(pwd, "db", "schema.rb")).
    split("\n").
    zip((1..1000).to_a).
    map { |(line, num)|
      x = line[/create_table \"(.*)\",.*/, 1]
      x && [x, num]
    }.
    compact
  lines = Hash[*tables.flatten]
  Finder.present do
    match_list(tables.map(&:first))
    vim_handler { |selection|
      line = lines[selection]
      "silent edit +#{line} db/schema.rb | normal zt"
    }
  end
RUBY
endfunction
