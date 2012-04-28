ruby <<RUBY
$LOAD_PATH << File.expand_path("~/.vim/ruby")
require "command-t-finders"
RUBY

function! CommandTShowMyFileFinder(base)
  let g:command_t_finder_name="find"
ruby << RUBY
  wildignore = ::VIM::evaluate('&wildignore').split(",").map { |v| "-not -name \"#{v}\"" }.join(" ")
  files = `find #{::VIM::evaluate("a:base")} #{wildignore} -type f`.split("\n")
  Finder.present do
    match_list(files, 30, 2)
    open_selection_
  end
RUBY
endfunction

function! GitStatusFinder()
  let g:command_t_finder_name="git status"
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
  let g:command_t_finder_name="Gemfile.lock"
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
  let g:command_t_finder_name="hoogle"
ruby << RUBY
Finder.present do
  run_command { |str|
    modules = VIM::evaluate("exists(\"g:hoogle_modules\") ? g:hoogle_modules : \"\" ")
    %`hoogle #{modules} -n 10 "#{str}"` 
  }
  copy_selection
end
RUBY
endfunction

function! CommandTShowMyTagFinder()
  let g:command_t_finder_name="tags"
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
