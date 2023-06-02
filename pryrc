Pry.config.editor = 'vim'

Pry.commands.alias_command('vi', 'edit')
Pry.commands.alias_command('vim', 'edit')

if (defined? PryByebug) || (defined? PryDebugger)
  Pry.commands.alias_command('c', 'continue') if Pry.commands.keys.include?("continue")
  Pry.commands.alias_command('s', 'step') if Pry.commands.keys.include?("step")
  Pry.commands.alias_command('n', 'next') if Pry.commands.keys.include?("next")
end

module Franky
  class << self
    def autoload(name)
      if try_with_require(name) || try_with_gem_which(name) || try_with_find(name) 
        puts "#{name} Loaded :)"
      else
        raise LoadError
      end
      yield if block_given?
    rescue LoadError => err
      puts "no #{name} :("
    end

    private

    def try_with_require(name)
      require name
    rescue LoadError => err
      false
    end

    def try_with_gem_which(name)
      path = `gem which #{name} 2>/dev/null`.strip
      return false if path.nil?
      $LOAD_PATH << File.dirname(path)
      require path
      true
    rescue LoadError => err
      false
    end

    def try_with_find(name)
      path = `find ~/.rbenv/versions/#{RUBY_VERSION}/ -iname "#{name}.rb"`.strip
      return false if path.nil?
      $LOAD_PATH << File.dirname(path)
      require path
      true
    rescue LoadError => err
      false
    end
  end
end

Franky.autoload("awesome_print") do
  AwesomePrint.defaults = {
    indent:-2,
  }
  Pry.config.print = proc { |output, value| output.puts value.ai }
  AwesomePrint.pry!
end
Franky.autoload("active_support/all")

if ENV['RAILS_ENV'] || defined?(Rails)
  # Some people soft-link this file and the railsrc file from ~/.*rc, others
  # load this file specifically into their own ~/.irbrc

  [Rails.root.join('.railsrc'), Rails.root.join('local_config', 'railsrc')].each do |railsrc|

    # puts "File.dirname #{File.dirname(__FILE__)}"
    # puts "Railsrc: #{railsrc}"
    # railsrc_path = File.dirname(__FILE__) + railsrc
    load railsrc if File.exist?(railsrc)
  end

  # ActiveRecord SQL to be printed to screen
  ActiveRecord::Base.logger = Logger.new(STDOUT)

  # Pry.config.prompt = [proc{ |object, nest_level, _| "#{Rails.env}.capitalize - #{object}:#{nest_level} > " }, proc{ |object, nest_level, _| "..."}]

  red     = "\033[0;31m"
  yellow  = "\033[0;33m"
  blue    = "\033[0;34m"
  default = "\033[0;39m"

  color = Rails.env =~ /production/ ? red : blue 
  Pry.config.prompt_name = "#{yellow}#{File.basename Rails.root}#{default} - #{color}#{Rails.env}#{default}"
end

