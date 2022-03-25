#!/usr/bin/env ruby

require 'git'
require 'optionparser'
require 'io/console'

module CoDy

    VERSION = '0.0.1'
    
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
        attr_reader :log_commands, :finalize_commands

        def initialize(&block)
            @repository_path = nil
            @log_commands = []
            @finalize_commands = []
            @chapter = nil
            self.instance_eval(&block)
        end

        def repo(path)
            @repository_path = path
            Git.open(@repository_path)
        end

        def check_for_repo
            abort("ERROR: You have to define the repository path with the 'repo(...) command first!'}") unless @repository_path
        end

        def log(&block)
            check_for_repo
            @chapter = :log
            self.instance_eval(&block)
        end

        def final(&block)
            check_for_repo
            @chapter = :final
            self.instance_eval(&block)
        end

        def <<(command)
            case @chapter
            when :log
                @log_commands << command
            when :final
                @finalize_commands << command
            else
                abort("ERROR: unknown chapter #{@chapter}")
            end
        end

        def position(mark)
            self << Checkout.new(@repository_path, mark)
        end

        def entry(text)
            self << Print.new(text)
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
                space = ' ' * 40
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

        def finalize()
            clear_screen
            puts "quit: finalize"
            puts "\n\n\n"
            @logbook.finalize_commands.each do |cmd|
                execute_command(cmd)
            end
        end

    end

    class App

        def run() 
            banner = "Usage: cody [options] inputfile"

            dryrun = false

            parser = OptionParser.new do |opts|
                opts.banner = banner
                opts.on('-v', '--version', 'show version') do
                puts VERSION  
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

            abort("No inputfile given!\n#{banner}") unless input_file

            logbook = eval File.read(input_file)

            abort("ERROR: logbook is empty!") unless logbook

            logbookRunner = LogBookRunner.new logbook, dryrun
            begin
                logbookRunner.execute
            ensure
                logbookRunner.finalize
            end

        end

    end

end

if __FILE__ == $PROGRAM_NAME
    app = CoDy::App.new
    app.run
end
