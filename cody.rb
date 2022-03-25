#!/usr/bin/env ruby

module CoDy
    
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
            @log_commands << mark
        end

        def entry(text)
            @log_commands << "entry"
        end

    end

end

input_file = ARGV.pop

logbook = eval File.read(input_file)
puts logbook.log_commands.join(', ')