class Finder < Struct.new(:matcher, :opener)
  def self.base
    Finder.new(proc { |str| [] }, proc { |sel| })
  end

  def sorted_matches_for str, options = {}
    matcher[str]
  end

  def open_selection(command, selection, options)
    # Un-escape spaces introduced by sanitize
    opener[selection.gsub("\\ ", " ").strip] 
  end

  def find_command(&p)
    self.matcher = proc { |str| 
      str.empty? ? [] : begin
                          xs = `#{p[str]}`.chomp.split("\n")
                          $?.success? ? xs : []
                        end
    }
    self
  end

  def grep_list(xs)
    self.matcher = proc { |str|
      xs.grep(/#{str}/)
    }
    self
  end

  def vim_handler(&p)
    self.opener = proc { |str| 
      cmds = p[str]
      cmds.split("\n").each do |c| VIM::command(c) end
    }
    self
  end

  def copy_selection
    vim_handler { |selection| ":let @* = \"#{selection}\"" }
    self
  end

end
