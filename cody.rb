#!/usr/bin/env ruby

require 'git'  # install with: sudo gem install git
require 'optionparser'
require 'io/console'

module CoDy
    
    class Command
        def execute
            raise "execute not implemented!"
        end

        def to_s
            vars = self.instance_variables.map do |name|
                val = self.instance_variable_get(name)
                "#{name}=#{val}"
            end
            "#{self.class.name}(#{vars.join(',')})"
        end
    end

    class Checkout < Command
        def initialize(repository_path, target)
            @repository_path = repository_path
            @target = target
        end
        def execute
            puts "checkout: #{@target}"
            g = Git.open(@repository_path)
            g.checkout(@target)
        end
    end

    class Print < Command
        def initialize(text)
            @text = text
        end
        def execute
            puts @text
        end
    end

    class LogBook
        attr_reader :log_commands

        def initialize(config = {}, &block)
            @repository_path = nil
            @log_commands = []
            self.instance_eval(&block)
        end

        def repo(path)
            @repository_path = path
        end

        def check_for_repo
            abort("ERROR: You have to define the repository path with the 'repo(...) command first!'}") unless @repository_path
        end

        def log(&block)
            check_for_repo
            self.instance_eval(&block)
        end

        def position(mark)
            @log_commands << Checkout.new(@repository_path, mark)
        end

        def entry(text)
            @log_commands << Print.new(text)
        end

    end

    class LogBookRunner
        def initialize(logbook, dryrun =true)
            @logbook = logbook
            @dryrun = dryrun
        end

        def clear_screen
            Gem.win_platform? ? (system "cls") : (system "clear")
        end

        def get_next_step(step, key_pressed)
            case key_pressed
            when "q"
                -1
            when "p"
                if step > 0
                    step - 1
                else
                    step
                end
            when " "
                step + 1
            else
                step
            end
        end

        def execute_command(cmd)
            if @dryrun
                puts "#{cmd}"
            else
                cmd.execute
            end
        end

        def execute()
            step = 0
            commands_count = @logbook.log_commands.size
            while step < commands_count && step >= 0
                cmd = @logbook.log_commands[step]
                clear_screen
                mode = @dryrun ? "DRYRUN" : "EXECUTE"
                space = ' ' * 60
                stepText = "| #{space} Step #{step + 1}/#{commands_count} #{space} |"
                puts "\n\n\n"
                puts '-' * stepText.size
                puts stepText
                puts '-' * stepText.size
                puts "\n\n\n"
                execute_command(cmd)
                puts "\n\n\n"
                puts '-' * stepText.size
                puts "[#{mode}] press space for the next step, 'p' for the previous step and 'q' to quit ..."           
                key_pressed = STDIN.getch
                step = get_next_step(step, key_pressed)
            end
        end

    end

end

BANNER = "Usage: woc [options] inputfile"

dryrun = false

parser = OptionParser.new do |opts|
    opts.banner = BANNER
    opts.on('-v', '--version', 'show version') do
      puts Woc::VERSION  
      exit
    end
    opts.on("-h", "--help", "print help") do
      puts opts
      exit
    end
    opts.on("-n", "--dry-run", "do a dry run") do
        dryrun = true
    end
  end.parse!

input_file = ARGV.pop

abort("No inputfile given!\n#{BANNER}") unless input_file

logbook = eval File.read(input_file)
logbookRunner = CoDy::LogBookRunner.new logbook, dryrun
logbookRunner.execute