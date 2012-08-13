ruby <<RUBY
$LOAD_PATH << File.expand_path("~/.vim/ruby")
require "command-t-finders"
RUBY

function! AckLol()
ruby << RUBY
Finder.present do
  run_command(15) { |str|
    cleaned = str.gsub(/\s+/, ".*")
    %`ack --nogroup "#{cleaned}"`
  }
  vim_handler { |sel|
    _, line, num = *sel.match(/(.*):(\d+).*/)
    ":e +#{num} #{line}"
  }
end
RUBY
endfunction

function! CommandTShowMyFileFinder(base)
ruby << RUBY
  wildignore = ::VIM::evaluate('&wildignore').split(",").map { |v| "-not -path \"#{v}\"" }.join(" ")
  files = `find #{::VIM::evaluate("a:base")} #{wildignore} -type f`.split("\n")
  Finder.present do
    match_list(files, 30, 0)
    open_selection_
  end
RUBY
nmap <buffer> @ <cr>/
endfunction

function! GitStatusFinder()
ruby << RUBY
  files = `git status -s --porcelain`.chomp.split("\n")
  Finder.present do
    match_list(files)
    vim_handler { |sel|
      "silent! :e #{sel[/.*\s+(.*)/, 1]}"
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

function! CommandTShowHoogleFinder()
ruby << RUBY
Finder.present do
  run_command { |str|
    _,modules,_,str = *str.match(/((\+[a-z,\-]+\s)*)(.*)/)
    %`hoogle #{modules} -n 10 "#{str}"` 
  }
  copy_selection
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
