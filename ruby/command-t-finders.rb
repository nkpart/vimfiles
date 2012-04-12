class Finder < Struct.new(:generator, :opener)
  # 'DSL' style
  def self.present(&blk)
    v = base
    v.instance_eval(&blk)
    v.show!
  end

  # 'fluent' style
  def self.base
    Finder.new(proc { |str| [] }, proc { |sel| })
  end

  ###################################
  ### CommandT::Matcher interface

  def sorted_matches_for str, options = {}
    generator[str]
  end

  def open_selection(command, selection, options)
    # Un-escape spaces introduced by sanitize (command-t internal thing)
    opener[selection.gsub("\\ ", " ").strip] 
  end

  ###################################

  # GENERATORS 

  def generate_with(&p)
    self.generator = p
    self
  end
  
  def run_command(&command_creator)
    generate_with { |input| 
      return [] if input.empty?
      xs = `#{command_creator[input]}`.chomp.split("\n")
      $?.success? ? xs : []
    }
  end

  def grep_list(xs)
    generate_with { |input| xs.grep(/#{input}/) }
  end

  def match_list(xs, max_items = 100, min_input = 0)
    class <<xs; def paths; self; end; end unless xs.respond_to?(:paths)
    m = CommandT::Matcher.new(xs)
    generate_with { |test| 
      if min_input > 0 && test && test.length < min_input
        []
      else
        m.matches_for(test).sort_by { |x| -x.score }[0..max_items].map { |x| x.to_s } 
      end
    }
  end

  # SELECTORS

  def open_with(&p)
    self.opener = p
    self
  end

  def vim_handler(&p)
    open_with { |selection|
      VIM::command(p[selection])
    }
  end

  def copy_selection
    vim_handler { |selection| ":let @* = \"#{selection}\"" }
  end
  
  def open_selection_
    vim_handler { |selection| "silent :e #{selection}" }
  end

  def show!
    $command_t.show_finder(self)
  end
end
