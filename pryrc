Pry.config.editor = 'vim'

Pry.commands.alias_command('vi', 'edit')
Pry.commands.alias_command('vim', 'edit')

if (defined? PryByebug) || (defined? PryDebugger)
  Pry.commands.alias_command('c', 'continue')
  Pry.commands.alias_command('s', 'step')
  Pry.commands.alias_command('n', 'next')
end

begin
  require 'awesome_print' 
  Pry.config.print = proc { |output, value| output.puts value.ai }
  AwesomePrint.defaults = {
    indent:-2,
  }
  AwesomePrint.pry!
  puts 'AwesomePrint Loaded'
rescue LoadError => err
  puts 'no awesome_print :('
end

if ENV['RAILS_ENV'] || defined?(Rails)
  # Some people soft-link this file and the railsrc file from ~/.*rc, others
  # load this file specifically into their own ~/.irbrc

  [Rails.root.join('.railsrc'), Rails.root.join('local_config', 'railsrc')].each do |railsrc|

    # puts "File.dirname #{File.dirname(__FILE__)}"
    # puts "Railsrc: #{railsrc}"
    # railsrc_path = File.dirname(__FILE__) + railsrc
    load railsrc if File.exists?(railsrc)
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
 
